import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final TeacherRepository _teacherRepository;
  final AudioService _audioService = AudioService.instance;

  ForgotPasswordBloc({
    required ForgotPasswordState initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<ForgotPasswordScreenCreated>(_screenCreated);
    on<ForgotPasswordUsernameChanged>(_usernameChanged);
    on<ForgotPasswordPasswordChanged>(_passwordChanged);
    on<ForgotPasswordConfirmPasswordChanged>(_confirmPasswordChanged);
    on<ForgotPasswordButtonPressed>(_buttonPressed);
    on<ForgotPasswordNextPressed>(_onNextPressed);
    on<ForgotPasswordObscurePasswordPressed>(_onObscurePasswordPressed);
    on<ForgotPasswordObscureConfirmPasswordPressed>(
      _onObscureConfirmPasswordPressed,
    );
    on<ForgotPasswordBgmToggled>(_bgmToggled);
    on<ForgotPasswordSfxToggled>(_sfxToggled);
    on<ForgotPasswordBgmVolumeChanged>(_bgmVolumeChanged);
    on<ForgotPasswordSfxVolumeChanged>(_sfxVolumeChanged);
    on<ForgotPasswordSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    ForgotPasswordScreenCreated event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    emit(
      state.copyWith(
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
      ),
    );
  }

  void _usernameChanged(
    ForgotPasswordUsernameChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.username(
        value: event.value,
        errorType: errorType,
      ),
    );
  }

  void _passwordChanged(
    ForgotPasswordPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.password(
        value: event.value,
        errorType: errorType,
      ),
    );
  }

  void _confirmPasswordChanged(
    ForgotPasswordConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else if (event.value != state.password.value) {
      errorType = ErrorType.value;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.confirmPassword(
        value: event.value,
        errorType: errorType,
      ),
    );
  }

  Future<void> _buttonPressed(
    ForgotPasswordButtonPressed event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    add(const ForgotPasswordSfxButtonPressed());
    emit(
      state.copyWith(
        teacherRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _teacherRepository.changePassword(
      id: state.admin?.id ?? 0,
      password: state.password.value,
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            teacherRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            teacherRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _onNextPressed(
    ForgotPasswordNextPressed event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    add(const ForgotPasswordSfxButtonPressed());
    emit(
      state.copyWith(
        nextRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _teacherRepository.verifyUsername(
      username: state.username.value,
    );

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            admin: result.data,
            currentStep: 2,
            password: const TextFieldInput(value: '', obscureText: true),
            confirmPassword: const TextFieldInput(value: '', obscureText: true),
            nextRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            username: state.username.copyWith(
              errorType: ErrorType.value,
            ),
            nextRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  void _onObscurePasswordPressed(
    ForgotPasswordObscurePasswordPressed event,
    Emitter<ForgotPasswordState> emit,
  ) {
    add(const ForgotPasswordSfxButtonPressed());
    emit(
      state.copyWith(
        password: state.password.copyWith(
          obscureText: !state.password.obscureText,
        ),
      ),
    );
  }

  void _onObscureConfirmPasswordPressed(
    ForgotPasswordObscureConfirmPasswordPressed event,
    Emitter<ForgotPasswordState> emit,
  ) {
    add(const ForgotPasswordSfxButtonPressed());
    emit(
      state.copyWith(
        confirmPassword: state.confirmPassword.copyWith(
          obscureText: !state.confirmPassword.obscureText,
        ),
      ),
    );
  }

  Future<void> _bgmToggled(
    ForgotPasswordBgmToggled event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }

    add(const ForgotPasswordSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    ForgotPasswordSfxToggled event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const ForgotPasswordSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    ForgotPasswordBgmVolumeChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    ForgotPasswordSfxVolumeChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    ForgotPasswordSfxButtonPressed event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
