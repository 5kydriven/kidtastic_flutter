import 'package:bloc/bloc.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../models/models.dart';
import 'bloc.dart';

class InitialScreenBloc extends Bloc<InitialScreenEvent, InitialScreenState> {
  final TeacherRepository _teacherRepository;

  InitialScreenBloc({
    required InitialScreenState initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<InitialScreenCreated>(_screenCreated);
  }

  Future<void> _screenCreated(
    InitialScreenCreated event,
    Emitter<InitialScreenState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _teacherRepository.getTeacher();

    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.success,
          ),
        );
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
}
