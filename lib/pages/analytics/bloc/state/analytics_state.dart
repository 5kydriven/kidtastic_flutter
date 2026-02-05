import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kidtastic_flutter/models/models.dart';

part 'analytics_state.freezed.dart';

@freezed
sealed class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(0) int totalStudents,
    @Default(0) int totalSessions,
    @Default(0) int totalMinutesPlayed,
    @Default(0.0) double averageAccuracy,
    @Default({}) Map<String, double> averageAccuracyByGame,
    @Default([]) List<RecentSession> recentSessions,
    @Default(0) int studentsChange,
    @Default(0) int sessionsChange,
    @Default(0) int minutesChange,
    @Default(0.0) double accuracyChange,
    // Phase 2 fields
    @Default([]) List<StudentRanking> topStudents,
    @Default([]) List<DailyActivity> dailyActivity,
    @Default([]) List<StudentRanking> lowPerformingStudents,
    @Default([]) List<StudentRanking> inactiveStudents,
  }) = _AnalyticsState;
}
