import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterState initialState;
  final TeacherRepository _teacherRepository;
  RegisterBloc({
    required this.initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<RegisterScreenCreated>(_screenCreated);
    on<RegisterNameChanged>(_nameChanged);
    on<RegisterEmailChanged>(_emailChanged);
    on<RegisterPasswordChanged>(_passwordChanged);
  }

  Future<void> _screenCreated(
    RegisterScreenCreated event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.success,
      ),
    );

    final result = await _teacherRepository.getTeacher();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            teacher: result.data,
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

  void _nameChanged(
    RegisterNameChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        name: TextFieldInput(value: event.name),
      ),
    );
  }

  void _emailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        email: TextFieldInput(value: event.email),
      ),
    );
  }

  void _passwordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        password: TextFieldInput(value: event.password),
      ),
    );
  }
}
