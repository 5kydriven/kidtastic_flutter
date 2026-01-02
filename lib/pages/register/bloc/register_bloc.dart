import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/utils/utils.dart';

import '../../../constants/constants.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterState initialState;
  final TeacherRepository _teacherRepository;
  final AudioService _audioService = AudioService.instance;

  RegisterBloc({
    required this.initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<RegisterScreenCreated>(_screenCreated);
    on<RegisterNameChanged>(_nameChanged);
    on<RegisterUsernameChanged>(_usernameChanged);
    on<RegisterPasswordChanged>(_passwordChanged);
    on<RegisterConfirmPasswordChanged>(_confirmPasswordChanged);
    on<RegisterButtonPressed>(_buttonPressed);
    on<RegisterObscurePasswordPressed>(_obscurePasswordPressed);
    on<RegisterSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    RegisterScreenCreated event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _teacherRepository.getTeacher();

    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );

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
    var errorType = ErrorType.empty;

    if (event.name.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.name(
        value: event.name,
        errorType: errorType,
      ),
    );
  }

  void _usernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
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
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
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

  void _confirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    var errorType = ErrorType.empty;

    if (event.confirmPassword.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.confirmPassword(
        value: event.confirmPassword,
        errorType: errorType,
      ),
    );
  }

  Future<void> _buttonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    add(const RegisterSfxButtonPressed());
    emit(
      state.copyWith(
        registerRequestStatus: RequestStatus.inProgress,
      ),
    );

    final hasError =
        state.name.value.isEmpty ||
        state.username.value.isEmpty ||
        state.password.value.isEmpty;

    emit(
      state.copyWith(
        name: state.name.copyWith(
          errorType: validateRequired(state.name.value),
        ),
        username: state.username.copyWith(
          errorType: validateRequired(state.username.value),
        ),
        password: state.password.copyWith(
          errorType: validateRequired(state.password.value),
        ),
        registerRequestStatus: RequestStatus.failure,
      ),
    );

    if (hasError) return;

    final result = await _teacherRepository.signUp(
      name: state.name.value,
      username: state.username.value,
      password: state.password.value,
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            registerRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            registerRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _obscurePasswordPressed(
    RegisterObscurePasswordPressed event,
    Emitter<RegisterState> emit,
  ) async {
    add(const RegisterSfxButtonPressed());
    emit(
      state.copyWith.password(
        obscureText: !state.password.obscureText,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    RegisterSfxButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
