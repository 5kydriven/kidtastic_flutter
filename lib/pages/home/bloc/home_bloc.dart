import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kidtastic_flutter/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StudentRepository _studentRepository;
  final AudioService _audioService = AudioService.instance;

  HomeBloc({
    required HomeState initialState,
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository,
       super(initialState) {
    on<HomeScreenCreated>(_screenCreated);
    on<HomeAddStudentPressed>(_addStudentPressed);
    on<HomeFirstNameChanged>(_firstNameChanged);
    on<HomeLastNameChanged>(_lastNameChanged);
    on<HomeDeleteStudentPressed>(_deleteStudentPressed);
    on<HomeNextButtonPressed>(_nextButtonPressed);
    on<HomePrevButtonPressed>(_prevButtonPressed);
    on<HomeAvatarSelected>(_avatarSelected);
    on<HomeErrorTypeCleared>(_errorTypeCleared);
    on<HomeSfxButtonPressed>(_sfxButtonPressed);
    on<HomeBgmToggled>(_bgmToggled);
    on<HomeSfxToggled>(_sfxToggled);
    on<HomeBgmVolumeChanged>(_bgmVolumeChanged);
    on<HomeSfxVolumeChanged>(_sfxVolumeChanged);
    on<HomeGenderChanged>(_genderChanged);
  }

  Future<void> _screenCreated(
    HomeScreenCreated event,
    Emitter<HomeState> emit,
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
    HomeAddStudentPressed event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        studentRequestStatus: RequestStatus.inProgress,
      ),
    );

    add(const HomeSfxButtonPressed());

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
        add(const HomeScreenCreated());
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
    HomeFirstNameChanged event,
    Emitter<HomeState> emit,
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
    HomeLastNameChanged event,
    Emitter<HomeState> emit,
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
    HomeDeleteStudentPressed event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
      ),
    );

    add(const HomeSfxButtonPressed());

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
        add(const HomeScreenCreated());
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
    HomeNextButtonPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: state.currentPage + 1,
      ),
    );
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

  void _avatarSelected(
    HomeAvatarSelected event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAvatar: event.avatar,
      ),
    );
  }

  void _errorTypeCleared(
    HomeErrorTypeCleared event,
    Emitter<HomeState> emit,
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
    HomeSfxButtonPressed event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  Future<void> _bgmToggled(
    HomeBgmToggled event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }
    add(const HomeSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    HomeSfxToggled event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const HomeSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    HomeBgmVolumeChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    HomeSfxVolumeChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _genderChanged(
    HomeGenderChanged event,
    Emitter<HomeState> emit,
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
