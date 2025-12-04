import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class MatchGameBloc extends Bloc<MatchGameEvent, MatchGameState> {
  final MatchGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;

  final AudioPlayer player = AudioPlayer();

  MatchGameBloc({
    required this.initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       super(initialState) {
    on<MatchGameScreenCreated>(_screenCreated);
    on<MatchGameItemDropped>(_itemDropped);
    on<MatchGameQuestionNext>(_questionNext);
    on<MatchGameGameEnd>(_gameEnd);
  }

  Future<void> _screenCreated(
    MatchGameScreenCreated event,
    Emitter<MatchGameState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
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
          limit: 5,
          isRandom: true,
        );

        switch (gameQuestionResult.resultStatus) {
          case ResultStatus.success:
            emit(
              state.copyWith(
                sessionId: gameSessionResult.data ?? 0,
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

    await player.setVolume(1.0);
    if (isCorrect) {
      await player.play(AssetSource(Assets.correctRecord));
      emit(
        state.copyWith(
          droppedItem: event.question,
          score: isCorrect ? state.score + 1 : state.score,
        ),
      );
    } else {
      await player.play(AssetSource(Assets.wrongChime));
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
        player.stop();
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

    final result = await _gameSessionRepository.endSession(
      sessionId: state.sessionId ?? 0,
      score: state.score,
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            gameSessionRequestStatus: RequestStatus.success,
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

  @override
  Future<void> close() async {
    await player.dispose();
    return super.close();
  }
}
