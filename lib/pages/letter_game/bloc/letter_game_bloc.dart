import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class LetterGameBloc extends Bloc<LetterGameEvent, LetterGameState> {
  final LetterGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final StudentInsightRepository _studentInsightRepository;

  final AudioService _audioService = AudioService.instance;

  LetterGameBloc({
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
    on<LetterGameScreenCreated>(_screenCreated);
    on<LetterGameTraceDone>(_traceDone);
    on<LetterGameNextQuestion>(_nextQuestion);
    on<LetterGameGameEnd>(_gameEnd);
    on<LetterGameBgmToggled>(_bgmToggled);
    on<LetterGameSfxToggled>(_sfxToggled);
    on<LetterGameBgmVolumeChanged>(_bgmVolumeChanged);
    on<LetterGameSfxVolumeChanged>(_sfxVolumeChanged);
    on<LetterGameSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    LetterGameScreenCreated event,
    Emitter<LetterGameState> emit,
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
          limit: 30,
          isRandom: false,
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

  Future<void> _traceDone(
    LetterGameTraceDone event,
    Emitter<LetterGameState> emit,
  ) async {
    emit(
      state.copyWith(
        sessionQuestionRequestStatus: RequestStatus.inProgress,
      ),
    );

    _audioService.playSfx(Audios.applause);
    _audioService.playSfx(Audios.correctRecord);

    final sessionQuestionResult = await _sessionQuestionRepository
        .addSessionQuestion(
          entry: SessionQuestion(
            sessionId: state.sessionId ?? 0,
            questionId: state.question[state.currentIndex].id ?? 0,
            studentAnswer: state.question[state.currentIndex].correctAnswer,
            isCorrect: true,
          ),
        );

    switch (sessionQuestionResult.resultStatus) {
      case ResultStatus.success:
        add(const LetterGameNextQuestion());

        emit(
          state.copyWith(
            score: state.score + 1,
            sessionQuestionRequestStatus: RequestStatus.success,
          ),
        );
        await Future.delayed(
          const Duration(
            milliseconds: 2000,
          ),
        );
        _audioService.stop();
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

  Future<void> _nextQuestion(
    LetterGameNextQuestion event,
    Emitter<LetterGameState> emit,
  ) async {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex == state.question.length) {
      emit(
        state.copyWith(
          hasEnded: true,
        ),
      );
      add(const LetterGameGameEnd());
      return;
    }

    emit(
      state.copyWith(
        currentIndex: nextIndex,
      ),
    );
  }

  Future<void> _gameEnd(
    LetterGameGameEnd event,
    Emitter<LetterGameState> emit,
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
    LetterGameBgmToggled event,
    Emitter<LetterGameState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const LetterGameSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    LetterGameSfxToggled event,
    Emitter<LetterGameState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const LetterGameSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    LetterGameBgmVolumeChanged event,
    Emitter<LetterGameState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    LetterGameSfxVolumeChanged event,
    Emitter<LetterGameState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    LetterGameSfxButtonPressed event,
    Emitter<LetterGameState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
