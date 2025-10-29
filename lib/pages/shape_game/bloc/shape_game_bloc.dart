import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class ShapeGameBloc extends Bloc<ShapeGameEvent, ShapeGameState> {
  final ShapeGameState initialState;
  final GameQuestionRepository _gameQuestionRepository;
  final GameSessionRepository _gameSessionRepository;
  final SessionQuestionRepository _sessionQuestionRepository;
  ShapeGameBloc({
    required this.initialState,
    required GameQuestionRepository gameQuestionRepository,
    required GameSessionRepository gameSessionRepository,
    required SessionQuestionRepository sessionQuestionRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameSessionRepository = gameSessionRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       super(initialState) {
    on<ShapeGameScreenCreated>(_screenCreated);
    on<ShapeGameButtonPressed>(_buttonPressed);
    on<ShapeGameNextQuestion>(_nextQuestion);
    on<ShapeGameGameEnd>(_gameEnd);
  }

  Future<void> _screenCreated(
    ShapeGameScreenCreated event,
    Emitter<ShapeGameState> emit,
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

        log('game:  ${gameQuestionResult.data}');

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

  Future<void> _buttonPressed(
    ShapeGameButtonPressed event,
    Emitter<ShapeGameState> emit,
  ) async {
    emit(
      state.copyWith(
        sessionQuestionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final isCorrect =
        state.question[state.currentIndex].correctAnswer == event.answer;

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
        emit(
          state.copyWith(
            score: isCorrect ? state.score + 1 : state.score,
            sessionQuestionRequestStatus: RequestStatus.success,
          ),
        );
        add(const ShapeGameNextQuestion());
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
    ShapeGameNextQuestion event,
    Emitter<ShapeGameState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= state.question.length) {
      add(const ShapeGameGameEnd());
      return;
    }

    emit(
      state.copyWith(
        currentIndex: nextIndex,
      ),
    );
  }

  Future<void> _gameEnd(
    ShapeGameGameEnd event,
    Emitter<ShapeGameState> emit,
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
}
