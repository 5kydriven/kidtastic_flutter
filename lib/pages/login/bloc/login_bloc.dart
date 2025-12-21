import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../models/models.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginState initialState;
  final TeacherRepository _teacherRepository;
  LoginBloc({
    required this.initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<LoginButtonPressed>(_buttonPressed);
    on<LoginUsernameChanged>(_usernameChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    on<LoginObscurePasswordPressed>(_obscurePasswordPressed);
  }

  Future<void> _buttonPressed(
    LoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _teacherRepository.signIn(
      username: state.username.value,
      password: state.password.value,
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

  void _usernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) async {
    var errorType = ErrorType.empty;

    if (event.username.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.username(
        value: event.username,
        errorType: errorType,
      ),
    );
  }

  void _passwordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    var errorType = ErrorType.empty;

    if (event.password.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.password(
        value: event.password,
        errorType: errorType,
      ),
    );
  }

  void _obscurePasswordPressed(
    LoginObscurePasswordPressed event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith.password(
        obscureText: !state.password.obscureText,
      ),
    );
  }
}
