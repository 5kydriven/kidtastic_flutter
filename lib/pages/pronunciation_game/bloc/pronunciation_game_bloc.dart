import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../services/services.dart';
import 'bloc.dart';

class PronunciationGameBloc
    extends Bloc<PronunciationGameEvent, PronunciationGameState> {
  final PronunciationGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final SpeechRecognitionService _speechService;
  final PronunciationAttemptRepository _pronunciationAttemptRepository;

  StreamSubscription<String>? _textSub;
  StreamSubscription<bool>? _recSub;
  StreamSubscription<bool>? _silenceSub;

  final AudioPlayer _soundPlayer = AudioPlayer();
  Timer? _maxTimer;

  PronunciationGameBloc({
    required this.initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required SpeechRecognitionService speechService,
    required PronunciationAttemptRepository pronunciationAttemptRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _speechService = speechService,
       _pronunciationAttemptRepository = pronunciationAttemptRepository,
       super(initialState) {
    on<PronunciationGameScreenCreated>(_screenCreated);
    on<PronunciationGameSessionFetched>(_sessionFetched);
    on<PronunciationGameQuestionNext>(_questionNext);
    on<PronunciationGameGameEnd>(_gameEnd);
    on<PronunciationGameRecordingToggle>(_recordingToggle);
    on<PronunciationGameTextRecognized>(_onTextRecognized);
  }

  Future<void> _screenCreated(
    PronunciationGameScreenCreated event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(state.copyWith(screenRequestStatus: RequestStatus.inProgress));

    await _speechService.initialize();

    // Listen for recognized text
    _textSub = _speechService.textStream.listen((recognizedText) {
      add(PronunciationGameTextRecognized(recognizedText));
    });

    // ✅ Listen for silence >1.5–2s
    _silenceSub = _speechService.silenceStream.listen((isSilent) {
      if (isSilent && _speechService.isRecording) {
        log('Detected silence >1.5s — stopping recording.');
        add(const PronunciationGameRecordingToggle());
      }
    });

    add(const PronunciationGameSessionFetched());
  }

  Future<void> _sessionFetched(
    PronunciationGameSessionFetched event,
    Emitter<PronunciationGameState> emit,
  ) async {
    final gameSessionResult = await _gameSessionRepository.startSession(
      studentId: state.student?.id ?? 0,
      gameId: state.game?.id ?? 0,
    );

    if (gameSessionResult.resultStatus == ResultStatus.success) {
      final gameQuestionResult = await _gameQuestionRepository
          .getRandomQuestion(
            gameId: state.game?.id ?? 0,
            limit: 5,
          );

      if (gameQuestionResult.resultStatus == ResultStatus.success) {
        emit(
          state.copyWith(
            sessionId: gameSessionResult.data ?? 0,
            question: gameQuestionResult.data ?? [],
            score: 0,
            currentIndex: 0,
            screenRequestStatus: RequestStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            question: [],
            screenRequestStatus: RequestStatus.failure,
          ),
        );
      }
    } else {
      emit(state.copyWith(screenRequestStatus: RequestStatus.failure));
    }
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

    emit(state.copyWith(currentIndex: nextIndex));
  }

  Future<void> _gameEnd(
    PronunciationGameGameEnd event,
    Emitter<PronunciationGameState> emit,
  ) async {
    emit(state.copyWith(gameSessionRequestStatus: RequestStatus.inProgress));

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
    if (_speechService.isRecording) {
      await _stopRecording(emit);
    } else {
      _speechService.clearText();
      await _soundPlayer.play(AssetSource(Assets.startRecord));
      await _soundPlayer.setVolume(1.0);
      await _speechService.startRecording();

      // ✅ 8s max timeout
      _maxTimer?.cancel();
      _maxTimer = Timer(const Duration(seconds: 8), () {
        if (_speechService.isRecording) {
          add(const PronunciationGameRecordingToggle());
        }
      });

      emit(
        state.copyWith(
          isRecording: true,
        ),
      );
    }
  }

  void _onTextRecognized(
    PronunciationGameTextRecognized event,
    Emitter<PronunciationGameState> emit,
  ) async {
    final current = state.question[state.currentIndex];
    final expectedText = current.question?.toLowerCase().trim() ?? '';
    final recognizedText = event.recognizedText.toLowerCase().trim();

    final similarity = _calculateSimilarity(expectedText, recognizedText);
    final isCorrect = similarity >= 0.8;
    final confidence = (similarity * 100).clamp(0, 100);

    emit(
      state.copyWith(
        recognizedText: event.recognizedText,
        isCorrect: isCorrect,
        confidenceScore: double.parse(confidence.toStringAsFixed(2)),
      ),
    );

    if (isCorrect && _speechService.isRecording) {
      await _soundPlayer.play(AssetSource(Assets.correctRecord));
      await _soundPlayer.setVolume(1.0);
      await _stopRecording(emit);
    }
  }

  Future<void> _stopRecording(Emitter<PronunciationGameState> emit) async {
    _maxTimer?.cancel();
    await _speechService.stopRecording();
    _speechService.clearText();
    emit(
      state.copyWith(
        isRecording: false,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _textSub?.cancel();
    await _recSub?.cancel();
    await _silenceSub?.cancel();
    _maxTimer?.cancel();
    _speechService.dispose();
    return super.close();
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final m = List.generate(
      s1.length + 1,
      (i) => List<int>.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          m[i][j] = j;
        } else if (j == 0) {
          m[i][j] = i;
        } else {
          m[i][j] = min(
            min(m[i - 1][j] + 1, m[i][j - 1] + 1),
            m[i - 1][j - 1] + (s1[i - 1] == s2[j - 1] ? 0 : 1),
          );
        }
      }
    }

    final distance = m[s1.length][s2.length];
    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (distance / maxLen);
  }
}
