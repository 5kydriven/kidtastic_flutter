import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/student_profile_event.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/state/student_profile_state.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvent, StudentProfileState> {
  final AudioService _audioService = AudioService.instance;
  final GameSessionRepository _gameSessionRepository;
  final StudentInsightRepository _studentInsightRepository;
  final GameRepository _gameRepository;

  StudentProfileBloc({
    required StudentProfileState initialState,
    required GameSessionRepository gameSessionRepository,
    required StudentInsightRepository studentInsightRepository,
    required GameRepository gameRepository,
  }) : _gameSessionRepository = gameSessionRepository,
       _studentInsightRepository = studentInsightRepository,
       _gameRepository = gameRepository,
       super(initialState) {
    on<StudentProfileScreenCreated>(_screenCreated);
    on<StudentProfileSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    StudentProfileScreenCreated event,
    Emitter<StudentProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.inProgress,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    final studentId = state.student?.id;
    if (studentId == null) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          isBgmMuted: isBgmMuted,
          isSfxMuted: isSfxMuted,
          bgmVolume: bgmVolume,
          sfxVolume: sfxVolume,
        ),
      );
      return;
    }

    // Fetch all sessions for this student
    final sessionsResult = await _gameSessionRepository.getSessionsByStudent(
      studentId: studentId,
    );

    // Fetch game insights
    final insightsResult = await _studentInsightRepository.getStudentInsight(
      studentId: studentId,
      gameId: 0, // Get all games
    );

    // Fetch games for mapping
    final gamesResult = await _gameRepository.getGames();

    if (sessionsResult.resultStatus == ResultStatus.success &&
        insightsResult.resultStatus == ResultStatus.success &&
        gamesResult.resultStatus == ResultStatus.success) {
      final sessions = sessionsResult.data ?? [];
      final insights = insightsResult.data ?? [];
      final games = gamesResult.data ?? [];

      // Calculate overall stats
      final totalSessions = sessions.length;
      final totalQuestions = sessions.fold<int>(
        0,
        (sum, s) => sum + (s.totalQuestions ?? 0),
      );
      final totalCorrect = sessions.fold<int>(
        0,
        (sum, s) => sum + (s.score ?? 0),
      );
      final overallAccuracy = totalQuestions > 0
          ? (totalCorrect / totalQuestions) * 100
          : 0.0;

      // Calculate total minutes played from durationSeconds
      final totalDurationSeconds = sessions.fold<int>(
        0,
        (sum, s) => sum + (s.durationSeconds ?? 0),
      );
      final totalMinutesPlayed = (totalDurationSeconds / 60).round();

      // Calculate streak
      final streaks = _calculateStreaks(sessions);

      // Get recent sessions (last 5)
      final recentSessions = List<GameSession>.from(sessions)
        ..sort(
          (a, b) => (b.endedAt ?? DateTime.now()).compareTo(
            a.endedAt ?? DateTime.now(),
          ),
        );

      emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          isBgmMuted: isBgmMuted,
          isSfxMuted: isSfxMuted,
          bgmVolume: bgmVolume,
          sfxVolume: sfxVolume,
          overallAccuracy: overallAccuracy,
          totalSessions: totalSessions,
          totalQuestionsAttempted: totalQuestions,
          totalCorrectAnswers: totalCorrect,
          totalMinutesPlayed: totalMinutesPlayed,
          currentStreak: streaks['current'] ?? 0,
          longestStreak: streaks['longest'] ?? 0,
          gameInsights: insights,
          recentSessions: recentSessions.take(5).toList(),
          games: games,
        ),
      );
    } else {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          isBgmMuted: isBgmMuted,
          isSfxMuted: isSfxMuted,
          bgmVolume: bgmVolume,
          sfxVolume: sfxVolume,
        ),
      );
    }
  }

  Map<String, int> _calculateStreaks(List<GameSession> sessions) {
    if (sessions.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    // Get unique dates with sessions
    final sessionDates = sessions
        .where((s) => s.endedAt != null)
        .map((s) => DateTime(s.endedAt!.year, s.endedAt!.month, s.endedAt!.day))
        .toSet()
        .toList();

    sessionDates.sort((a, b) => b.compareTo(a)); // Most recent first

    // Calculate current streak
    int currentStreak = 0;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    DateTime checkDate = todayDate;
    for (final date in sessionDates) {
      if (date.isAtSameMomentAs(checkDate) ||
          (currentStreak == 0 &&
              date.isAtSameMomentAs(
                todayDate.subtract(const Duration(days: 1)),
              ))) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }

    // Calculate longest streak
    int longestStreak = 0;
    int currentCount = 0;
    DateTime? previousDate;

    final sortedDates = List<DateTime>.from(sessionDates)..sort();

    for (final date in sortedDates) {
      if (previousDate == null || date.difference(previousDate).inDays == 1) {
        currentCount++;
      } else {
        longestStreak = currentCount > longestStreak
            ? currentCount
            : longestStreak;
        currentCount = 1;
      }
      previousDate = date;
    }
    longestStreak = currentCount > longestStreak ? currentCount : longestStreak;

    return {'current': currentStreak, 'longest': longestStreak};
  }

  Future<void> _sfxButtonPressed(
    StudentProfileSfxButtonPressed event,
    Emitter<StudentProfileState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
