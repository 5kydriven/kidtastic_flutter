import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GameRepository _gameRepository;
  HomeBloc({
    required GameRepository gameRepository,
    required HomeState initialState,
  }) : _gameRepository = gameRepository,
       super(initialState) {
    on<HomeScreenCreated>(_screenCreated);
    on<HomePrevButtonPressed>(_prevButtonPressed);
    on<HomeNextButtonPressed>(_nextButtonPressed);
  }

  Future<void> _screenCreated(
    HomeScreenCreated event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );
    final result = await _gameRepository.getGames();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            games: result.data ?? [],
            screenRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.failure,
            games: [],
          ),
        );
        break;
    }
  }

  void _prevButtonPressed(
    HomePrevButtonPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: state.currentPage - 1,
      ),
    );
  }

  void _nextButtonPressed(
    HomeNextButtonPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: state.currentPage + 1,
      ),
    );
  }
}
