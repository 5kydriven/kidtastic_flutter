import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import 'bloc.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final StudentRepository _studentRepository;
  final GameSessionRepository _gameSessionRepository;

  StudentListBloc({
    required StudentListState initialState,
    required StudentRepository studentRepository,
    required GameSessionRepository gameSessionRepository,
  }) : _studentRepository = studentRepository,
       _gameSessionRepository = gameSessionRepository,
       super(initialState) {
    on<StudentListScreenCreated>(_screenCreated);
    on<StudentListGameSessionFetched>(_gameSessionFetched);
  }

  Future<void> _screenCreated(
    StudentListScreenCreated event,
    Emitter<StudentListState> emit,
  ) async {
    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _studentRepository.getStudents();

    switch (result.resultStatus) {
      case ResultStatus.success:
        final studentsData = result.data ?? [];

        // Wait for all lastPlayedAt fetches
        final students = await Future.wait(
          studentsData.map((e) async {
            final lastPlayedAt = await _gameSessionRepository
                .getLastPlayedForStudent(
                  studentId: e.id ?? 0,
                );
            return Student(
              id: e.id,
              name: e.name,
              firstName: e.firstName,
              lastName: e.lastName,
              gender: e.gender,
              image: e.image,
              isSynced: e.isSynced,
              lastPlayedAt: lastPlayedAt.data,
            );
          }),
        );

        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.success,
            students: students,
          ),
        );

        add(const StudentListGameSessionFetched());
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

  Future<void> _gameSessionFetched(
    StudentListGameSessionFetched event,
    Emitter<StudentListState> emit,
  ) async {
    emit(
      state.copyWith(
        gameSessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _gameSessionRepository.getTodaySessions();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            gameSessionRequestStatus: RequestStatus.success,
            gameSessions: result.data ?? [],
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            gameSessions: [],
            gameSessionRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }
}
