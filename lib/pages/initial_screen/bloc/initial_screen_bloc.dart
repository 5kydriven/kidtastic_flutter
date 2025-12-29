import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kidtastic_flutter/service/services.dart';

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
  }

  Future<void> _screenCreated(
    InitialScreenScreenCreated event,
    Emitter<InitialScreenState> emit,
  ) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
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
        state.firstName.value.isEmpty || state.lastName.value.isEmpty;

    emit(
      state.copyWith(
        firstName: state.firstName.copyWith(
          errorType: validateRequired(state.firstName.value),
        ),
        lastName: state.lastName.copyWith(
          errorType: validateRequired(state.lastName.value),
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
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    InitialScreenSfxButtonPressed event,
    Emitter<InitialScreenState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
