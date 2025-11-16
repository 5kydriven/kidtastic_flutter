// pronunciation_game_bloc.dart
import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/workers/sherpa_worker.dart';
import 'package:record/record.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';

class PronunciationGameBloc
    extends Bloc<PronunciationGameEvent, PronunciationGameState> {
  final PronunciationGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final PronunciationAttemptRepository _pronunciationAttemptRepository;

  late final AudioRecorder _audioRecorder;
  final AudioPlayer _soundPlayer = AudioPlayer();

  // Sherpa objects live in worker; keep reference so we can reset/create streams locally if needed
  sherpa.OnlineRecognizer? _recognizer;
  sherpa.OnlineStream? _stream;
  final int _sampleRate = 16000;

  // isolate comms
  Isolate? _sherpaIsolate;
  SendPort? _sherpaSend;
  late ReceivePort _sherpaReceivePort;
  late ReceivePort _sherpaInitPort;

  StreamSubscription<RecordState>? _recordSub;
  Timer? _maxTimer;
  Timer? _silenceTimer;

  bool _isInitialized = false;

  // Accumulate recognized text during a single recording session
  String _accumulatedText = '';

  PronunciationGameBloc({
    required this.initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required PronunciationAttemptRepository pronunciationAttemptRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _pronunciationAttemptRepository = pronunciationAttemptRepository,
       super(initialState) {
    on<PronunciationGameScreenCreated>(_screenCreated);
    on<PronunciationGameSessionFetched>(_sessionFetched);
    on<PronunciationGameQuestionNext>(_questionNext);
    on<PronunciationGameGameEnd>(_gameEnd);
    on<PronunciationGameRecordingToggle>(_recordingToggle);
    on<PronunciationGameTextRecognized>(_onTextRecognized);
    on<PronunciationGameModelReady>(_onModelReady);
  }

  Future<void> _screenCreated(
    PronunciationGameScreenCreated event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );

    if (!_isInitialized) {
      _audioRecorder = AudioRecorder();

      _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
        debugPrint('Record state changed: $recordState');
      });

      await _startSherpaIsolate();
      _isInitialized = true;
    }

    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.success,
      ),
    );

    add(const PronunciationGameSessionFetched());
  }

  Future<void> _startSherpaIsolate() async {
    _sherpaInitPort = ReceivePort();

    _sherpaIsolate = await Isolate.spawn(
      sherpaWorker,
      _sherpaInitPort.sendPort,
      debugName: 'SherpaWorker',
    );

    _sherpaSend = await _sherpaInitPort.first as SendPort;
    _sherpaInitPort.close();

    _sherpaReceivePort = ReceivePort();
    _sherpaReceivePort.listen((msg) {
      if (msg is Map && msg['type'] == 'ready') {
        add(const PronunciationGameModelReady());
      } else if (msg is Map && msg['type'] == 'result') {
        final text = msg['text'] as String? ?? '';
        add(PronunciationGameTextRecognized(text));
      } else if (msg is Map && msg['type'] == 'silence') {
        _handleSilenceTimeout();
      }
    });

    final modelConfig = await getOnlineModelConfig(type: 0);
    final config = sherpa.OnlineRecognizerConfig(
      model: modelConfig,
      ruleFsts: '',
    );

    _sherpaSend!.send({
      'type': 'init',
      'config': config,
      'replyPort': _sherpaReceivePort.sendPort,
      'quietFramesForSilence': 100,
    });
  }

  Future<void> _sessionFetched(
    PronunciationGameSessionFetched event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(
      state.copyWith(
        sessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final gameSessionResult = await _gameSessionRepository.startSession(
      studentId: state.student?.id ?? 0,
      gameId: state.game?.id ?? 0,
    );

    if (gameSessionResult.resultStatus != ResultStatus.success) {
      emit(
        state.copyWith(
          sessionRequestStatus: RequestStatus.failure,
        ),
      );
      return;
    }

    final gameQuestionResult = await _gameQuestionRepository.getQuestion(
      gameId: state.game?.id ?? 0,
      limit: 5,
    );

    if (gameQuestionResult.resultStatus != ResultStatus.success ||
        (gameQuestionResult.data?.isEmpty ?? true)) {
      emit(
        state.copyWith(
          question: [],
          sessionRequestStatus: RequestStatus.failure,
        ),
      );
      return;
    }

    final firstQuestion = gameQuestionResult.data!.first;
    final sessionQuestionResult = await _sessionQuestionRepository
        .addSessionQuestion(
          entry: SessionQuestion(
            sessionId: gameSessionResult.data ?? 0,
            questionId: firstQuestion.id ?? 0,
          ),
        );

    emit(
      state.copyWith(
        sessionId: gameSessionResult.data ?? 0,
        question: gameQuestionResult.data ?? [],
        score: 0,
        currentIndex: 0,
        currentSessionQuestionId: sessionQuestionResult.data ?? 0,
        sessionRequestStatus: RequestStatus.success,
      ),
    );
  }

  Future<void> _questionNext(
    PronunciationGameQuestionNext event,
    Emitter<PronunciationGameState> emit,
  ) async {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.question.length) {
      add(const PronunciationGameGameEnd());
      return;
    }

    final result = await _sessionQuestionRepository.addSessionQuestion(
      entry: SessionQuestion(
        sessionId: state.sessionId ?? 0,
        questionId: state.question[state.currentIndex].id ?? 0,
      ),
    );

    emit(
      state.copyWith(
        currentIndex: nextIndex,
        currentSessionQuestionId: result.data ?? 0,
        recognizedText: '',
        isCorrect: false,
        confidenceScore: 0,
      ),
    );

    _accumulatedText = '';

    _sherpaSend?.send({'type': 'reset'});
  }

  Future<void> _gameEnd(
    PronunciationGameGameEnd event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(
      state.copyWith(
        gameSessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _gameSessionRepository.endSession(
      sessionId: state.sessionId ?? 0,
      score: state.score,
    );

    emit(
      state.copyWith(
        gameSessionRequestStatus: result.resultStatus == ResultStatus.success
            ? RequestStatus.success
            : RequestStatus.failure,
      ),
    );
  }

  Future<void> _recordingToggle(
    PronunciationGameRecordingToggle event,
    Emitter<PronunciationGameState> emit,
  ) async {
    final currentlyRecording = state.isRecording;

    if (!currentlyRecording) {
      emit(
        state.copyWith(
          isRecording: true,
          recognizedText: '',
          isCorrect: false,
          confidenceScore: 0,
        ),
      );

      _accumulatedText = '';

      _sherpaSend?.send({'type': 'reset'});

      await _soundPlayer.setVolume(1.0);
      await _soundPlayer.play(
        AssetSource(Assets.startRecord),
      );

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 128000,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
      );

      try {
        final stream = await _audioRecorder.startStream(config);
        stream.listen(
          (data) {
            try {
              final samplesFloat32 = convertBytesToFloat32(
                Uint8List.fromList(data),
              );
              _sherpaSend?.send({
                'type': 'audio',
                'samples': samplesFloat32,
                'sampleRate': _sampleRate,
              });

              _resetSilenceTimer();
            } catch (e, st) {
              debugPrint('Error while streaming audio: $e\n$st');
            }
          },
          onDone: () => debugPrint('audio stream done'),
          onError: (e, st) => debugPrint('audio stream error: $e\n$st'),
        );
      } catch (e) {
        debugPrint('startStream error: $e');
      }

      _startMaxTimer();
      _resetSilenceTimer();
    } else {
      await _stopRecording(
        emit,
        triggeredByUser: true,
      );
    }
  }

  Future<void> _onTextRecognized(
    PronunciationGameTextRecognized event,
    Emitter<PronunciationGameState> emit,
  ) async {
    if (!state.isRecording) return;

    final recognizedRaw = event.recognizedText;
    debugPrint('text recognized: $recognizedRaw');

    _accumulatedText = recognizedRaw;

    final current = state.question.isNotEmpty
        ? state.question[state.currentIndex]
        : null;
    final expectedText = current?.question?.toLowerCase().trim() ?? '';

    final recognizedWords = _accumulatedText
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    double bestSimilarity = 0.0;
    String bestMatch = '';

    for (final word in recognizedWords) {
      final similarity = calculateSimilarity(expectedText, word);
      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatch = word;
      }
    }

    final fullSimilarity = calculateSimilarity(
      expectedText,
      _accumulatedText.toLowerCase().trim(),
    );
    if (fullSimilarity > bestSimilarity) {
      bestSimilarity = fullSimilarity;
      bestMatch = _accumulatedText.trim();
    }

    final isCorrect = bestSimilarity >= 0.8;
    final confidence = (bestSimilarity * 100).clamp(0, 100);

    debugPrint(
      'Expected: "$expectedText" | Best match: "$bestMatch" | Similarity: $bestSimilarity',
    );

    _resetSilenceTimer();

    emit(
      state.copyWith(
        recognizedText: recognizedRaw,
        isCorrect: isCorrect,
        confidenceScore: double.parse(confidence.toStringAsFixed(2)),
      ),
    );

    if (isCorrect) {
      await _stopRecording(
        emit,
        triggeredByUser: false,
        wasCorrect: true,
      );
    }
  }

  Future<void> _stopRecording(
    Emitter<PronunciationGameState> emit, {
    bool triggeredByUser = false,
    bool wasCorrect = false,
  }) async {
    final finalIsCorrect = wasCorrect || state.isCorrect;
    final finalRecognized = state.recognizedText;
    final finalConfidence = state.confidenceScore;

    _maxTimer?.cancel();
    _silenceTimer?.cancel();

    try {
      await _audioRecorder.stop();
    } catch (e) {
      debugPrint('audioRecorder.stop() error: $e');
    }

    await _recordSub?.cancel();
    _recordSub = null;

    _accumulatedText = '';

    _sherpaSend?.send({'type': 'reset'});

    try {
      await _pronunciationAttemptRepository.addAttempt(
        attempt: PronunciationAttempt(
          isCorrect: finalIsCorrect,
          sessionQuestionId: state.currentSessionQuestionId ?? 0,
          recognizedText: finalRecognized,
          word: state.question.isNotEmpty
              ? state.question[state.currentIndex].question ?? ''
              : '',
          confidence: finalConfidence,
        ),
      );
    } catch (e) {
      debugPrint('Error saving attempt: $e');
    }

    emit(
      state.copyWith(
        attempts: state.attempts + 1,
        isRecording: false,
        isCorrect: false,
      ),
    );

    if (finalIsCorrect) {
      try {
        await _soundPlayer.setVolume(1.0);
        await _soundPlayer.play(AssetSource(Assets.correctRecord));
      } catch (e) {
        debugPrint('play correct sound error: $e');
      }

      await Future.delayed(
        const Duration(
          milliseconds: 300,
        ),
      );

      emit(
        state.copyWith(
          recognizedText: '',
          confidenceScore: 0,
          isCorrect: false,
        ),
      );

      add(const PronunciationGameQuestionNext());
    } else {
      // not correct: if user triggered stop, UI already reflects stopped. If automatic stop (silence/max) we do nothing more.
    }
  }

  void _startMaxTimer() {
    _maxTimer?.cancel();
    _maxTimer = Timer(
      state.maxRecordingTime,
      () {
        if (state.isRecording) {
          add(const PronunciationGameRecordingToggle());
        }
      },
    );
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(
      state.silenceTimeout,
      () {
        _handleSilenceTimeout();
      },
    );
  }

  void _handleSilenceTimeout() {
    if (state.isRecording) {
      add(const PronunciationGameRecordingToggle());
    }
  }

  Future<void> _onModelReady(
    PronunciationGameModelReady event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(
      state.copyWith(
        isModelReady: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    try {
      _sherpaSend?.send({'type': 'dispose'});
    } catch (_) {}
    try {
      _sherpaReceivePort.close();
    } catch (_) {}
    try {
      _sherpaIsolate?.kill(priority: Isolate.immediate);
    } catch (_) {}
    await _recordSub?.cancel();
    try {
      await _audioRecorder.dispose();
    } catch (_) {}
    try {
      _stream?.free();
      _recognizer?.free();
    } catch (_) {}
    _silenceTimer?.cancel();
    _maxTimer?.cancel();
    return super.close();
  }
}
