import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';

class StudentEditBloc extends Bloc<StudentEditEvent, StudentEditState> {
  final StudentRepository _studentRepository;
  final AudioService _audioService = AudioService.instance;

  StudentEditBloc({
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository,
       super(const StudentEditState()) {
    on<StudentEditScreenCreated>(_screenCreated);
    on<StudentEditFirstNameChanged>(_firstNameChanged);
    on<StudentEditLastNameChanged>(_lastNameChanged);
    on<StudentEditGenderChanged>(_genderChanged);
    on<StudentEditAvatarSelected>(_avatarSelected);
    on<StudentEditSavePressed>(_savePressed);
    on<StudentEditErrorTypeCleared>(_errorTypeCleared);
    on<StudentEditSfxButtonPressed>(_sfxButtonPressed);
  }

  void _screenCreated(
    StudentEditScreenCreated event,
    Emitter<StudentEditState> emit,
  ) {
    final student = event.student;
    emit(
      state.copyWith(
        student: student,
        firstName: TextFieldInput(
          value: student.firstName ?? '',
        ),
        lastName: TextFieldInput(
          value: student.lastName ?? '',
        ),
        gender: TextFieldInput(
          value: student.gender ?? '',
        ),
        selectedAvatar: student.image ?? Assets.sheepAvatar,
      ),
    );
  }

  void _firstNameChanged(
    StudentEditFirstNameChanged event,
    Emitter<StudentEditState> emit,
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
    StudentEditLastNameChanged event,
    Emitter<StudentEditState> emit,
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

  void _genderChanged(
    StudentEditGenderChanged event,
    Emitter<StudentEditState> emit,
  ) {
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

  void _avatarSelected(
    StudentEditAvatarSelected event,
    Emitter<StudentEditState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAvatar: event.avatar,
      ),
    );
  }

  void _errorTypeCleared(
    StudentEditErrorTypeCleared event,
    Emitter<StudentEditState> emit,
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

  Future<void> _savePressed(
    StudentEditSavePressed event,
    Emitter<StudentEditState> emit,
  ) async {
    emit(
      state.copyWith(
        studentRequestStatus: RequestStatus.inProgress,
      ),
    );

    add(const StudentEditSfxButtonPressed());

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
        studentRequestStatus: hasError ? RequestStatus.failure : RequestStatus.waiting,
      ),
    );

    if (hasError) return;

    final response = await _studentRepository.updateStudent(
      id: state.student?.id ?? 0,
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
            studentRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            studentRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _sfxButtonPressed(
    StudentEditSfxButtonPressed event,
    Emitter<StudentEditState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
