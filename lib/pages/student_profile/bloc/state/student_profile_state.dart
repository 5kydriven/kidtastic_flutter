import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'student_profile_state.freezed.dart';

@freezed
sealed class StudentProfileState with _$StudentProfileState {
  const factory StudentProfileState({
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
    Student? student,
    
    // Overall Stats
    @Default(0.0) double overallAccuracy,
    @Default(0) int totalSessions,
    @Default(0) int totalQuestionsAttempted,
    @Default(0) int totalCorrectAnswers,
    @Default(0) int totalMinutesPlayed,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    
    // Per-Game Stats
    @Default([]) List<StudentInsight> gameInsights,
    
    // Recent Activity
    @Default([]) List<GameSession> recentSessions,
    @Default([]) List<Game> games,
    @Default({}) Map<int, double> sessionAccuracyMap,
    
    // Audio settings
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
  }) = _StudentProfileState;
}
