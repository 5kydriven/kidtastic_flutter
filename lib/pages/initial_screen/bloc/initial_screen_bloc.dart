import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kidtastic_flutter/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';

class InitialScreenBloc extends Bloc<InitialScreenEvent, InitialScreenState> {
  final StudentRepository _studentRepository;
  final AudioService _audioService = AudioService.instance;

  InitialScreenBloc({
    required InitialScreenState initialState,
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository,
       super(initialState) {
    on<InitialScreenScreenCreated>(_screenCreated);
    on<InitialScreenAddStudentPressed>(_addStudentPressed);
    on<InitialScreenFirstNameChanged>(_firstNameChanged);
    on<InitialScreenLastNameChanged>(_lastNameChanged);
    on<InitialScreenDeleteStudentPressed>(_deleteStudentPressed);
    on<InitialScreenNextButtonPressed>(_nextButtonPressed);
    on<InitialScreenPrevButtonPressed>(_prevButtonPressed);
    on<InitialScreenAvatarSelected>(_avatarSelected);
    on<InitialScreenErrorTypeCleared>(_errorTypeCleared);
    on<InitialScreenSfxButtonPressed>(_sfxButtonPressed);
    on<InitialScreenBgmToggled>(_bgmToggled);
    on<InitialScreenSfxToggled>(_sfxToggled);
    on<InitialScreenBgmVolumeChanged>(_bgmVolumeChanged);
    on<InitialScreenSfxVolumeChanged>(_sfxVolumeChanged);
    on<InitialScreenGenderChanged>(_genderChanged);
  }

  Future<void> _screenCreated(
    InitialScreenScreenCreated event,
    Emitter<InitialScreenState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
      ),
    );

    final response = await _studentRepository.getStudents();
    switch (response.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            students: response.data ?? [],
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _addStudentPressed(
    InitialScreenAddStudentPressed event,
    Emitter<InitialScreenState> emit,
  ) async {
    emit(
      state.copyWith(
        studentRequestStatus: RequestStatus.inProgress,
      ),
    );

    add(const InitialScreenSfxButtonPressed());

    final hasError =
        state.firstName.value.isEmpty ||
        state.lastName.value.isEmpty ||
        state.gender.value.isEmpty;

    emit(
      state.copyWith(
        firstName: state.firstName.copyWith(
          errorType: validateRequired(state.firstName.value),
        ),
        lastName: state.lastName.copyWith(
          errorType: validateRequired(state.lastName.value),
        ),
        gender: state.gender.copyWith(
          errorType: validateRequired(state.gender.value),
        ),
        studentRequestStatus: RequestStatus.failure,
      ),
    );

    if (hasError) return;

    final response = await _studentRepository.addStudent(
      student: Student(
        name: '${state.firstName.value} ${state.lastName.value}',
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        image: state.selectedAvatar,
        gender: state.gender.value,
      ),
    );

    switch (response.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            firstName: TextFieldInput(
              value: '',
            ),
            lastName: TextFieldInput(
              value: '',
            ),
            gender: TextFieldInput(
              value: '',
            ),
            studentRequestStatus: RequestStatus.success,
          ),
        );
        add(const InitialScreenScreenCreated());
        break;
      default:
        emit(
          state.copyWith(
            firstName: TextFieldInput(
              value: '',
            ),
            lastName: TextFieldInput(
              value: '',
            ),
            gender: TextFieldInput(
              value: '',
            ),
            studentRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  void _firstNameChanged(
    InitialScreenFirstNameChanged event,
    Emitter<InitialScreenState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.firstName(
        value: event.value,
        errorType: errorType,
      ),
    );
  }

  void _lastNameChanged(
    InitialScreenLastNameChanged event,
    Emitter<InitialScreenState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.lastName(
        value: event.value,
        errorType: errorType,
      ),
    );
  }

  Future<void> _deleteStudentPressed(
    InitialScreenDeleteStudentPressed event,
    Emitter<InitialScreenState> emit,
  ) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
      ),
    );

    add(const InitialScreenSfxButtonPressed());

    final response = await _studentRepository.deleteStudent(
      id: event.id,
    );

    switch (response.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
          ),
        );
        add(const InitialScreenScreenCreated());
        break;
      default:
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  void _nextButtonPressed(
    InitialScreenNextButtonPressed event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: state.currentPage + 1,
      ),
    );
  }

  void _prevButtonPressed(
    InitialScreenPrevButtonPressed event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: state.currentPage - 1,
      ),
    );
  }

  void _avatarSelected(
    InitialScreenAvatarSelected event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAvatar: event.avatar,
      ),
    );
  }

  void _errorTypeCleared(
    InitialScreenErrorTypeCleared event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        firstName: state.firstName.copyWith(
          errorType: ErrorType.none,
        ),
        lastName: state.lastName.copyWith(
          errorType: ErrorType.none,
        ),
        gender: state.gender.copyWith(
          errorType: ErrorType.none,
        ),
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    InitialScreenSfxButtonPressed event,
    Emitter<InitialScreenState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  Future<void> _bgmToggled(
    InitialScreenBgmToggled event,
    Emitter<InitialScreenState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }
    add(const InitialScreenSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    InitialScreenSfxToggled event,
    Emitter<InitialScreenState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const InitialScreenSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    InitialScreenBgmVolumeChanged event,
    Emitter<InitialScreenState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    InitialScreenSfxVolumeChanged event,
    Emitter<InitialScreenState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _genderChanged(
    InitialScreenGenderChanged event,
    Emitter<InitialScreenState> emit,
  ) async {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.gender(
        value: event.value,
        errorType: errorType,
      ),
    );
  }
}
