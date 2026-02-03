import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class MatchGameBloc extends Bloc<MatchGameEvent, MatchGameState> {
  final MatchGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  final StudentInsightRepository _studentInsightRepository;

  final AudioService _audioService = AudioService.instance;

  MatchGameBloc({
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
    on<MatchGameScreenCreated>(_screenCreated);
    on<MatchGameItemDropped>(_itemDropped);
    on<MatchGameQuestionNext>(_questionNext);
    on<MatchGameGameEnd>(_gameEnd);
    on<MatchGameBgmToggled>(_bgmToggled);
    on<MatchGameSfxToggled>(_sfxToggled);
    on<MatchGameBgmVolumeChanged>(_bgmVolumeChanged);
    on<MatchGameSfxVolumeChanged>(_sfxVolumeChanged);
    on<MatchGameSfxButtonPressed>(_sfxButtonPressed);
    on<MatchGameTutorialStarted>(_tutorialStarted);
    on<MatchGameTutorialNextPressed>(_tutorialNext);
    on<MatchGameTutorialFinished>(_tutorialFinished);
  }

  Future<void> _screenCreated(
    MatchGameScreenCreated event,
    Emitter<MatchGameState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
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

  Future<void> _itemDropped(
    MatchGameItemDropped event,
    Emitter<MatchGameState> emit,
  ) async {
    emit(
      state.copyWith(
        sessionQuestionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final isCorrect =
        state.question[state.currentIndex].correctAnswer ==
        event.question.correctAnswer;

    if (isCorrect) {
      _audioService.playSfx(Audios.correctRecord);
      emit(
        state.copyWith(
          droppedItem: event.question,
          score: isCorrect ? state.score + 1 : state.score,
        ),
      );
    } else {
      await _audioService.playSfx(Audios.wrongChime);
    }

    final sessionQuestionResult = await _sessionQuestionRepository
        .addSessionQuestion(
          entry: SessionQuestion(
            sessionId: state.sessionId ?? 0,
            questionId: state.question[state.currentIndex].id ?? 0,
            studentAnswer: event.question.correctAnswer,
            isCorrect: isCorrect,
          ),
        );

    switch (sessionQuestionResult.resultStatus) {
      case ResultStatus.success:
        await Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
        add(const MatchGameQuestionNext());

        emit(
          state.copyWith(
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

  void _questionNext(
    MatchGameQuestionNext event,
    Emitter<MatchGameState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex == state.question.length) {
      emit(
        state.copyWith(
          hasEnded: true,
        ),
      );
      add(const MatchGameGameEnd());
      return;
    }
    emit(
      state.copyWith(
        currentIndex: nextIndex,
        droppedItem: state.question[nextIndex],
      ),
    );
  }

  Future<void> _gameEnd(
    MatchGameGameEnd event,
    Emitter<MatchGameState> emit,
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

    final result = await _gameSessionRepository.endSession(
      sessionId: state.sessionId ?? 0,
      score: state.score,
      totalQuestions: state.question.length,
      durationSeconds: durationSeconds,
    );

    switch (result.resultStatus) {
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
    MatchGameBgmToggled event,
    Emitter<MatchGameState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const MatchGameSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    MatchGameSfxToggled event,
    Emitter<MatchGameState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const MatchGameSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    MatchGameBgmVolumeChanged event,
    Emitter<MatchGameState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    MatchGameSfxVolumeChanged event,
    Emitter<MatchGameState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    MatchGameSfxButtonPressed event,
    Emitter<MatchGameState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  void _tutorialStarted(
    MatchGameTutorialStarted event,
    Emitter<MatchGameState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: MatchGameTutorialStep.welcome,
      ),
    );
  }

  void _tutorialNext(
    MatchGameTutorialNextPressed event,
    Emitter<MatchGameState> emit,
  ) {
    final nextStep = switch (state.tutorialStep) {
      MatchGameTutorialStep.welcome => MatchGameTutorialStep.question,
      MatchGameTutorialStep.question => MatchGameTutorialStep.buttons,
      MatchGameTutorialStep.buttons => MatchGameTutorialStep.finished,
      _ => MatchGameTutorialStep.finished,
    };

    emit(
      state.copyWith(
        tutorialStep: nextStep,
      ),
    );
  }

  void _tutorialFinished(
    MatchGameTutorialFinished event,
    Emitter<MatchGameState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: MatchGameTutorialStep.none,
      ),
    );
  }
}
