import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'student_list_state.freezed.dart';

@freezed
sealed class StudentListState with _$StudentListState {
  const factory StudentListState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus studentRequestStatus,
    @Default([]) List<Student> students,
    @Default([]) List<GameSession> gameSessions,
    @Default(0.5) double bgmVolume,
    @Default(0.5) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
  }) = _StudentListState;
}
