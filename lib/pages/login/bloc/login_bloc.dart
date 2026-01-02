import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../service/services.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginState initialState;
  final TeacherRepository _teacherRepository;
  final AudioService _audioService = AudioService.instance;

  LoginBloc({
    required this.initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<LoginButtonPressed>(_buttonPressed);
    on<LoginUsernameChanged>(_usernameChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    on<LoginObscurePasswordPressed>(_obscurePasswordPressed);
    on<LoginSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _buttonPressed(
    LoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    add(const LoginSfxButtonPressed());
    emit(
      state.copyWith(
        loginRequestStatus: RequestStatus.inProgress,
      ),
    );

    final hasError =
        state.username.value.isEmpty || state.password.value.isEmpty;

    emit(
      state.copyWith(
        username: state.username.copyWith(
          errorType: validateRequired(state.username.value),
        ),
        password: state.password.copyWith(
          errorType: validateRequired(state.password.value),
        ),
      ),
    );

    if (hasError) return;

    final result = await _teacherRepository.signIn(
      username: state.username.value,
      password: state.password.value,
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            loginRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            loginRequestStatus: RequestStatus.failure,
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

  Future<void> _sfxButtonPressed(
    LoginSfxButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
