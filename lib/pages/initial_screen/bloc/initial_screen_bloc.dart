import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class InitialScreenBloc extends Bloc<InitialScreenEvent, InitialScreenState> {
  final StudentRepository _studentRepository;
  StreamSubscription? _subscription;

  InitialScreenBloc({
    required InitialScreenState initialState,
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository,
       super(initialState) {
    on<InitialScreenScreenCreated>(_screenCreated);
    on<InitialScreenAddStudentPressed>(_addStudentPressed);
    on<InitialScreenNameChanged>(_nameChanged);
    on<InitialScreenDeleteStudentPressed>(_deleteStudentPressed);
    on<InitialScreenStreamStudentsWatched>(_streamStudentsWatched);

    _startWatchingStudents();
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
        requestStatus: RequestStatus.inProgress,
      ),
    );

    final response = await _studentRepository.addStudent(
      student: Student(
        name: state.name?.value,
      ),
    );

    switch (response.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
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

  void _nameChanged(
    InitialScreenNameChanged event,
    Emitter<InitialScreenState> emit,
  ) {
    var errorType = ErrorType.empty;

    if (event.value.isEmpty) {
      errorType = ErrorType.empty;
    } else {
      errorType = ErrorType.none;
    }

    emit(
      state.copyWith.name!(
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

  void _streamStudentsWatched(
    InitialScreenStreamStudentsWatched event,
    Emitter<InitialScreenState> emit,
  ) {
    emit(
      state.copyWith(
        students: event.students,
      ),
    );
  }

  void _startWatchingStudents() {
    _subscription = _studentRepository.watchStudents().listen(
      (students) {
        add(InitialScreenStreamStudentsWatched(students: students));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
