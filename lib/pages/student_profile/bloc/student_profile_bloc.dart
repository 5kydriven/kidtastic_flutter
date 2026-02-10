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
  final SessionQuestionRepository _sessionQuestionRepository;
  final PronunciationAttemptRepository _pronunciationAttemptRepository;

  StudentProfileBloc({
    required StudentProfileState initialState,
    required GameSessionRepository gameSessionRepository,
    required StudentInsightRepository studentInsightRepository,
    required GameRepository gameRepository,
    required SessionQuestionRepository sessionQuestionRepository,
    required PronunciationAttemptRepository pronunciationAttemptRepository,
  }) : _gameSessionRepository = gameSessionRepository,
       _studentInsightRepository = studentInsightRepository,
       _gameRepository = gameRepository,
       _sessionQuestionRepository = sessionQuestionRepository,
       _pronunciationAttemptRepository = pronunciationAttemptRepository,
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

      // Filter to only completed sessions (user actually played)
      final completedSessions = await _filterCompletedSessions(sessions, games);

      // Calculate overall stats - only from completed sessions
      final totalSessions = completedSessions.length;
      int totalQuestions = 0;
      int totalCorrect = 0;

      for (final session in completedSessions) {
        final game = games.firstWhere(
          (g) => g.id == session.gameId,
          orElse: () => const Game(name: 'Unknown', category: ''),
        );

        if (game.category?.toLowerCase() == 'pronunciation') {
          // For pronunciation games, calculate from attempts
          final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
            session.id ?? 0,
          );
          if (sessionAccuracy >= 0) {
            final sessionQs = session.totalQuestions ?? 0;
            totalCorrect += ((sessionAccuracy / 100) * sessionQs).round();
            totalQuestions += sessionQs;
          }
        } else {
          // For other games, use session score
          totalCorrect += session.score ?? 0;
          totalQuestions += session.totalQuestions ?? 0;
        }
      }

      final overallAccuracy = totalQuestions > 0
          ? (totalCorrect / totalQuestions) * 100
          : 0.0;

      // Calculate total minutes played from completed sessions
      final totalDurationSeconds = completedSessions.fold<int>(
        0,
        (sum, s) => sum + (s.durationSeconds ?? 0),
      );
      final totalMinutesPlayed = (totalDurationSeconds / 60).round();

      // Calculate streak - only from completed sessions
      final streaks = _calculateStreaks(completedSessions);

      // Get recent sessions - only include completed sessions
      final recentSessions = completedSessions;

      // Sort by most recent first
      recentSessions.sort(
        (a, b) => (b.endedAt ?? DateTime.now()).compareTo(
          a.endedAt ?? DateTime.now(),
        ),
      );

      // Calculate accuracy for ALL sessions
      final sessionAccuracyMap = <int, double>{};
      for (final session in sessions) {
        final game = games.firstWhere(
          (g) => g.id == session.gameId,
          orElse: () => const Game(name: 'Unknown', category: ''),
        );

        if (game.category?.toLowerCase() == 'pronunciation') {
          final accuracy = await _calculatePronunciationSessionAccuracy(
            session.id ?? 0,
          );
          if (accuracy >= 0) {
            sessionAccuracyMap[session.id ?? 0] = accuracy;
          }
        }
      }

      // Recalculate pronunciation game insights from attempts
      final correctedInsights = <StudentInsight>[];
      for (final insight in insights) {
        final game = games.firstWhere(
          (g) => g.id == insight.gameId,
          orElse: () => const Game(name: 'Unknown', category: ''),
        );

        if (game.category?.toLowerCase() == 'pronunciation') {
          // Get all sessions for this student and game
          final gameSessions = sessions.where(
            (s) => s.gameId == insight.gameId && s.studentId == studentId,
          ).toList();

          int totalGameQuestions = 0;
          int totalGameCorrect = 0;

          for (final session in gameSessions) {
            final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
              session.id ?? 0,
            );
            if (sessionAccuracy >= 0) {
              final sessionQs = session.totalQuestions ?? 0;
              totalGameCorrect += ((sessionAccuracy / 100) * sessionQs).round();
              totalGameQuestions += sessionQs;
            }
          }

          final calculatedAverageScore = totalGameQuestions > 0
              ? (totalGameCorrect / totalGameQuestions) * 100
              : insight.averageScore ?? 0.0;

          correctedInsights.add(
            insight.copyWith(
              averageScore: calculatedAverageScore,
            ),
          );
        } else {
          correctedInsights.add(insight);
        }
      }

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
          gameInsights: correctedInsights,
          recentSessions: recentSessions, // Only completed sessions
          games: games,
          sessionAccuracyMap: sessionAccuracyMap,
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

  /// Filter sessions to only include completed/played sessions
  /// Removes sessions where user entered and quit without playing
  Future<List<GameSession>> _filterCompletedSessions(
    List<GameSession> sessions,
    List<Game> games,
  ) async {
    final completedSessions = <GameSession>[];

    for (final session in sessions) {
      final game = games.firstWhere(
        (g) => g.id == session.gameId,
        orElse: () => const Game(name: 'Unknown', category: ''),
      );

      // Skip sessions with no duration (user entered and quit immediately)
      if ((session.durationSeconds ?? 0) <= 0) {
        continue;
      }

      // For pronunciation games, also check if there are any attempts
      if (game.category?.toLowerCase() == 'pronunciation') {
        final accuracy = await _calculatePronunciationSessionAccuracy(
          session.id ?? 0,
        );
        // Skip if no attempts found (user didn't actually play)
        if (accuracy < 0) {
          continue;
        }
      }

      completedSessions.add(session);
    }

    return completedSessions;
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

  /// Calculate pronunciation accuracy for a specific session based on attempts
  /// Returns accuracy percentage (0-100) or -1 if no attempts found
  Future<double> _calculatePronunciationSessionAccuracy(int sessionId) async {
    if (sessionId == 0) return -1;
    
    // Get all session questions for this session
    final sessionQuestionsResult = await _sessionQuestionRepository
        .getSessionQuestions(sessionId: sessionId);

    if (sessionQuestionsResult.resultStatus != ResultStatus.success ||
        sessionQuestionsResult.data == null ||
        sessionQuestionsResult.data!.isEmpty) {
      return -1;
    }

    final sessionQuestions = sessionQuestionsResult.data!;
    
    final sessionQuestionIds = sessionQuestions
        .map((sq) => sq.id)
        .where((id) => id != null && id != 0)
        .cast<int>()
        .toList();

    if (sessionQuestionIds.isEmpty) return -1;

    // Get all attempts for these session questions
    int totalAttempts = 0;
    int correctAttempts = 0;

    for (final sessionQuestionId in sessionQuestionIds) {
      final attemptsResult = await _pronunciationAttemptRepository.getAttempts(
        sessionQuestionId: sessionQuestionId,
      );

      if (attemptsResult.resultStatus == ResultStatus.success &&
          attemptsResult.data != null) {
        final attempts = attemptsResult.data!;
        totalAttempts += attempts.length;
        correctAttempts += attempts.where((a) => a.isCorrect ?? false).length;
      }
    }

    if (totalAttempts == 0) return -1;

    // Calculate accuracy: (correct attempts / total attempts) * 100
    return (correctAttempts / totalAttempts) * 100;
  }
}
