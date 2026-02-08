import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class BubbleGameBloc extends Bloc<BubbleGameEvent, BubbleGameState> {
  final AudioService _audioService = AudioService.instance;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final StudentInsightRepository _studentInsightRepository;

  final FlutterTts flutterTts = FlutterTts();

  BubbleGameBloc({
    required BubbleGameState initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required StudentInsightRepository studentInsightRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _studentInsightRepository = studentInsightRepository,
       super(initialState) {
    on<BubbleGameScreenCreated>(_screenCreated);
    on<BubbleGameButtonPressed>(_buttonPressed);
    on<BubbleGameNextQuestion>(_nextQuestion);
    on<BubbleGameGameEnd>(_gameEnd);
    on<BubbleGamePositionsGenerated>(_positionsGenerated);
    on<BubbleGameBgmToggled>(_bgmToggled);
    on<BubbleGameSfxToggled>(_sfxToggled);
    on<BubbleGameBgmVolumeChanged>(_bgmVolumeChanged);
    on<BubbleGameSfxVolumeChanged>(_sfxVolumeChanged);
    on<BubbleGameSfxButtonPressed>(_sfxButtonPressed);
    on<BubbleGameTextSpeech>(_textSpeech);
  }

  Future<void> _screenCreated(
    BubbleGameScreenCreated event,
    Emitter<BubbleGameState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
        gameSessionRequestStatus: RequestStatus.waiting,
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
        hasEnded: false,
      ),
    );

    final gameSessionResult = await _gameSessionRepository.startSession(
      studentId: state.student?.id ?? 0,
      gameId: state.game?.id ?? 0,
    );

    switch (gameSessionResult.resultStatus) {
      case ResultStatus.success:
        final gameQuestionResult = await _gameQuestionRepository.getQuestion(
          gameId: state.game?.id ?? 0,
          limit: 10,
          isRandom: true,
        );

        switch (gameQuestionResult.resultStatus) {
          case ResultStatus.success:
            final sessionStartTime = DateTime.now();
            emit(
              state.copyWith(
                sessionId: gameSessionResult.data ?? 0,
                sessionStartTime: sessionStartTime,
                question: gameQuestionResult.data ?? [],
                score: 0,
                currentIndex: 0,
                screenRequestStatus: RequestStatus.success,
              ),
            );
            break;
          default:
            emit(
              state.copyWith(
                question: [],
                screenRequestStatus: RequestStatus.failure,
              ),
            );
            break;
        }
        break;
      default:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _buttonPressed(
    BubbleGameButtonPressed event,
    Emitter<BubbleGameState> emit,
  ) async {
    emit(
      state.copyWith(
        sessionQuestionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final isCorrect =
        state.question[state.currentIndex].correctAnswer == event.answer;

    if (isCorrect) {
      _audioService.playSfx(Audios.applause);
      _audioService.playSfx(Audios.correctRecord);
    } else {
      _audioService.playSfx(Audios.wrongChime);
    }

    final sessionQuestionResult = await _sessionQuestionRepository
        .addSessionQuestion(
          entry: SessionQuestion(
            sessionId: state.sessionId ?? 0,
            questionId: state.question[state.currentIndex].id ?? 0,
            studentAnswer: event.answer,
            isCorrect: isCorrect,
          ),
        );

    switch (sessionQuestionResult.resultStatus) {
      case ResultStatus.success:
        await Future.delayed(
          const Duration(
            milliseconds: 3000,
          ),
        );
        _audioService.stop();
        add(const BubbleGameNextQuestion());

        emit(
          state.copyWith(
            score: isCorrect ? state.score + 1 : state.score,
            sessionQuestionRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            sessionQuestionRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  void _nextQuestion(
    BubbleGameNextQuestion event,
    Emitter<BubbleGameState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex == state.question.length) {
      emit(
        state.copyWith(
          hasEnded: true,
        ),
      );
      add(const BubbleGameGameEnd());
      return;
    }

    emit(
      state.copyWith(
        currentIndex: nextIndex,
        imagePositions: [],
      ),
    );
  }

  Future<void> _gameEnd(
    BubbleGameGameEnd event,
    Emitter<BubbleGameState> emit,
  ) async {
    emit(
      state.copyWith(
        gameSessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final durationSeconds = state.sessionStartTime != null
        ? DateTime.now().difference(state.sessionStartTime!).inSeconds
        : 0;

    final gameSessionResult = await _gameSessionRepository.endSession(
      sessionId: state.sessionId ?? 0,
      score: state.score,
      totalQuestions: state.question.length,
      durationSeconds: durationSeconds,
    );

    switch (gameSessionResult.resultStatus) {
      case ResultStatus.success:
        final studentInsightResult = await _studentInsightRepository
            .updateStudentInsight(
              studentId: state.student?.id ?? 0,
              gameId: state.game?.id ?? 0,
            );

        emit(
          state.copyWith(
            gameSessionRequestStatus:
                studentInsightResult.resultStatus == ResultStatus.success
                ? RequestStatus.success
                : RequestStatus.failure,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            gameSessionRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  void _positionsGenerated(
    BubbleGamePositionsGenerated event,
    Emitter<BubbleGameState> emit,
  ) {
    const double bubbleSize = 100; // image width/height
    const double padding = 8; // space between bubbles
    const int maxAttempts = 100;

    final question = state.question[event.questionIndex];
    final count = (jsonDecode(question.choices ?? '[]') as List).length;

    final random = Random();
    final List<Offset> positions = [];

    final double minDistance = bubbleSize + padding;

    for (int i = 0; i < count; i++) {
      Offset? candidate;
      bool valid = false;

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final dx = random.nextDouble() * (event.maxWidth - bubbleSize);
        final dy = random.nextDouble() * (event.maxHeight - bubbleSize);

        candidate = Offset(dx, dy);

        valid = positions.every(
          (existing) => (candidate! - existing).distance >= minDistance,
        );

        if (valid) break;
      }

      // Fallback: allow slight overlap if space is tight
      candidate ??= Offset(
        random.nextDouble() * (event.maxWidth - bubbleSize),
        random.nextDouble() * (event.maxHeight - bubbleSize),
      );

      positions.add(candidate);
    }

    emit(
      state.copyWith(
        currentIndex: event.questionIndex,
        imagePositions: positions,
      ),
    );
  }

  Future<void> _bgmToggled(
    BubbleGameBgmToggled event,
    Emitter<BubbleGameState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const BubbleGameSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    BubbleGameSfxToggled event,
    Emitter<BubbleGameState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const BubbleGameSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    BubbleGameBgmVolumeChanged event,
    Emitter<BubbleGameState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    BubbleGameSfxVolumeChanged event,
    Emitter<BubbleGameState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    BubbleGameSfxButtonPressed event,
    Emitter<BubbleGameState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  Future<void> _textSpeech(
    BubbleGameTextSpeech event,
    Emitter<BubbleGameState> emit,
  ) async {
    emit(
      state.copyWith(
        isSpeaking: true,
      ),
    );

    await flutterTts.setPitch(1.6);
    await flutterTts.setSpeechRate(0.2);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(event.text);

    emit(
      state.copyWith(
        isSpeaking: false,
      ),
    );
  }
}
