import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/counting_game/bloc/bloc.dart';

class CountingGameBloc extends Bloc<CountingGameEvent, CountingGameState> {
  CountingGameBloc({
    required CountingGameState initialState,
  }) : super(initialState) {
    on<CountingGameScreenCreated>(_screenCreated);
  }

  Future<void> _screenCreated(
    CountingGameScreenCreated event,
    Emitter<CountingGameState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );
  }
}
