import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/color_game/bloc/bloc.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

class ColorGameBloc extends Bloc<ColorGameEvent, ColorGameState> {
  final AudioService _audioService = AudioService.instance;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final StudentInsightRepository _studentInsightRepository;

  ColorGameBloc({
    required ColorGameState initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required StudentInsightRepository studentInsightRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _studentInsightRepository = studentInsightRepository,
       super(initialState) {
    on<ColorGameScreenCreated>(_screenCreated);
    on<ColorGameButtonPressed>(_buttonPressed);
    on<ColorGameNextQuestion>(_nextQuestion);
    on<ColorGameGameEnd>(_gameEnd);
    on<ColorGameBgmToggled>(_bgmToggled);
    on<ColorGameSfxToggled>(_sfxToggled);
    on<ColorGameBgmVolumeChanged>(_bgmVolumeChanged);
    on<ColorGameSfxVolumeChanged>(_sfxVolumeChanged);
    on<ColorGameSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    ColorGameScreenCreated event,
    Emitter<ColorGameState> emit,
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
    ColorGameButtonPressed event,
    Emitter<ColorGameState> emit,
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
        add(const ColorGameNextQuestion());

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
    ColorGameNextQuestion event,
    Emitter<ColorGameState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex == state.question.length) {
      emit(
        state.copyWith(
          hasEnded: true,
        ),
      );
      add(const ColorGameGameEnd());
      return;
    }

    emit(
      state.copyWith(
        currentIndex: nextIndex,
      ),
    );
  }

  Future<void> _gameEnd(
    ColorGameGameEnd event,
    Emitter<ColorGameState> emit,
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

  Future<void> _bgmToggled(
    ColorGameBgmToggled event,
    Emitter<ColorGameState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const ColorGameSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    ColorGameSfxToggled event,
    Emitter<ColorGameState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const ColorGameSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    ColorGameBgmVolumeChanged event,
    Emitter<ColorGameState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    ColorGameSfxVolumeChanged event,
    Emitter<ColorGameState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    ColorGameSfxButtonPressed event,
    Emitter<ColorGameState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
