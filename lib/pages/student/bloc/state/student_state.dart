import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'student_state.freezed.dart';

@freezed
sealed class StudentState with _$StudentState {
  const factory StudentState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
    @Default([]) List<Student> students,
    @Default([]) List<GameSession> gameSessions,
  }) = _StudentState;
}
