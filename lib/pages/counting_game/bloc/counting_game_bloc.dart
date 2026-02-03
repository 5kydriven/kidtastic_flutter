import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/counting_game/bloc/bloc.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../service/services.dart';

class CountingGameBloc extends Bloc<CountingGameEvent, CountingGameState> {
  final CountingGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final StudentInsightRepository _studentInsightRepository;

  final AudioService _audioService = AudioService.instance;

  CountingGameBloc({
    required this.initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required StudentInsightRepository studentInsightRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _studentInsightRepository = studentInsightRepository,
       super(initialState) {
    on<CountingGameScreenCreated>(_screenCreated);
    on<CountingGameButtonPressed>(_buttonPressed);
    on<CountingGameNextQuestion>(_nextQuestion);
    on<CountingGameGameEnd>(_gameEnd);
    on<CountingGamePositionsGenerated>(_positionsGenerated);
    on<CountingGameBgmToggled>(_bgmToggled);
    on<CountingGameSfxToggled>(_sfxToggled);
    on<CountingGameBgmVolumeChanged>(_bgmVolumeChanged);
    on<CountingGameSfxVolumeChanged>(_sfxVolumeChanged);
    on<CountingGameSfxButtonPressed>(_sfxButtonPressed);
    on<CountingGameTutorialStarted>(_tutorialStarted);
    on<CountingGameTutorialNextPressed>(_tutorialNext);
    on<CountingGameTutorialFinished>(_tutorialFinished);
  }

  Future<void> _screenCreated(
    CountingGameScreenCreated event,
    Emitter<CountingGameState> emit,
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
    CountingGameButtonPressed event,
    Emitter<CountingGameState> emit,
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
        add(const CountingGameNextQuestion());

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
    CountingGameNextQuestion event,
    Emitter<CountingGameState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex == state.question.length) {
      emit(
        state.copyWith(
          hasEnded: true,
        ),
      );
      add(const CountingGameGameEnd());
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
    CountingGameGameEnd event,
    Emitter<CountingGameState> emit,
  ) async {
    emit(
      state.copyWith(
        gameSessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    // Calculate session duration
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
    CountingGamePositionsGenerated event,
    Emitter<CountingGameState> emit,
  ) {
    final question = state.question[event.questionIndex];
    final count = int.tryParse(question.correctAnswer ?? '0') ?? 0;
    final positions = List.generate(
      count,
      (_) => Offset(
        Random().nextDouble() * (event.maxWidth - 80),
        Random().nextDouble() * (event.maxHeight - 80),
      ),
    );

    emit(
      state.copyWith(
        currentIndex: event.questionIndex,
        imagePositions: positions,
      ),
    );
  }

  Future<void> _bgmToggled(
    CountingGameBgmToggled event,
    Emitter<CountingGameState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const CountingGameSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    CountingGameSfxToggled event,
    Emitter<CountingGameState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const CountingGameSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    CountingGameBgmVolumeChanged event,
    Emitter<CountingGameState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    CountingGameSfxVolumeChanged event,
    Emitter<CountingGameState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    CountingGameSfxButtonPressed event,
    Emitter<CountingGameState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  void _tutorialStarted(
    CountingGameTutorialStarted event,
    Emitter<CountingGameState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: CountingGameTutorialStep.welcome,
      ),
    );
  }

  void _tutorialNext(
    CountingGameTutorialNextPressed event,
    Emitter<CountingGameState> emit,
  ) {
    final nextStep = switch (state.tutorialStep) {
      CountingGameTutorialStep.welcome => CountingGameTutorialStep.question,
      CountingGameTutorialStep.question => CountingGameTutorialStep.contents,
      CountingGameTutorialStep.contents => CountingGameTutorialStep.buttons,
      CountingGameTutorialStep.buttons => CountingGameTutorialStep.finished,
      _ => CountingGameTutorialStep.finished,
    };

    emit(
      state.copyWith(
        tutorialStep: nextStep,
      ),
    );
  }

  void _tutorialFinished(
    CountingGameTutorialFinished event,
    Emitter<CountingGameState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: CountingGameTutorialStep.none,
      ),
    );
  }
}
