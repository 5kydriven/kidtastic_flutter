import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required HomeState initialState,
  }) : super(initialState) {
    on<HomePrevButtonPressed>(_prevButtonPressed);
    on<HomeNextButtonPressed>(_nextButtonPressed);
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
