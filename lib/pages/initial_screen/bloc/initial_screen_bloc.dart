import 'package:bloc/bloc.dart';

import '../../../models/models.dart';
import 'bloc.dart';

class InitialScreenBloc extends Bloc<InitialScreenEvent, InitialScreenState> {
  InitialScreenBloc({
    required InitialScreenState initialState,
  }) : super(initialState) {
    on<InitialScreenAddStudentPressed>(_addStudentPressed);
    on<InitialScreenNameChanged>(_nameChanged);
  }

  void _addStudentPressed(
    InitialScreenAddStudentPressed event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
      ),
    );
  }

  void _nameChanged(
    InitialScreenNameChanged event,
    Emitter<InitialScreenState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.name(
        value: event.value,
        errorType: errorType,
      ),
    );
  }
}
