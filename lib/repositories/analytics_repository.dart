import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/models/models.dart';

/// Extension to check if a game is the pronunciation game
extension GameCategoryCheck on GameTableData {
  bool get isPronunciationGame => category.toLowerCase() == 'pronunciation';
}

class AnalyticsRepository {
  final StudentDao _studentDao;
  final GameSessionDao _gameSessionDao;
  final GameDao _gameDao;
  final SessionQuestionDao _sessionQuestionDao;
  final PronunciationAttemptDao _pronunciationAttemptDao;

  const AnalyticsRepository({
    required StudentDao studentDao,
    required GameSessionDao gameSessionDao,
    required GameDao gameDao,
    required SessionQuestionDao sessionQuestionDao,
    required PronunciationAttemptDao pronunciationAttemptDao,
  }) : _studentDao = studentDao,
       _gameSessionDao = gameSessionDao,
       _gameDao = gameDao,
       _sessionQuestionDao = sessionQuestionDao,
       _pronunciationAttemptDao = pronunciationAttemptDao;

  Future<int> getTotalStudents() async {
    final students = await _studentDao.getAllStudents();
    return students.length;
  }

  Future<int> getTotalSessions() async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    return completedSessions.length;
  }

  Future<int> getTotalPlayTimeMinutes() async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    return completedSessions.fold(
          0,
          (sum, session) => sum + (session.durationSeconds ?? 0),
        ) ~/
        60;
  }

  Future<double> getAverageAccuracy() async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    if (completedSessions.isEmpty) return 0.0;

    int totalQuestions = 0;
    int totalCorrect = 0;

    for (final session in completedSessions) {
      final game = games.firstWhere(
        (g) => g.id == session.gameId,
        orElse: () => GameTableData(
          id: 0,
          name: 'Unknown',
          category: '',
          route: '',
          isSynced: false,
          syncedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      if (game.isPronunciationGame) {
        // For pronunciation games, calculate accuracy from attempts
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

    if (totalQuestions == 0) return 0.0;
    return (totalCorrect / totalQuestions) * 100;
  }

  Future<Map<String, double>> getAverageAccuracyByGame() async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);

    final gameAccuracyMap = <String, double>{};

    for (final game in games) {
      final gameSessions = completedSessions.where((s) => s.gameId == game.id).toList();
      if (gameSessions.isNotEmpty) {
        double totalPercentage = 0;
        int validSessions = 0;

        for (final session in gameSessions) {
          if (game.isPronunciationGame) {
            // For pronunciation games, calculate accuracy from attempts
            final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
              session.id ?? 0,
            );
            if (sessionAccuracy >= 0) {
              totalPercentage += sessionAccuracy;
              validSessions++;
            }
          } else {
            // For other games, use session score
            final score = session.score ?? 0;
            final totalQuestions = session.totalQuestions ?? 0;
            if (totalQuestions > 0) {
              totalPercentage += (score / totalQuestions) * 100;
              validSessions++;
            }
          }
        }

        gameAccuracyMap[game.name] = validSessions > 0
            ? totalPercentage / validSessions
            : 0.0;
      } else {
        gameAccuracyMap[game.name] = 0.0;
      }
    }

    return gameAccuracyMap;
  }

  /// Calculate pronunciation accuracy for a specific session based on attempts
  /// Returns accuracy percentage (0-100) or -1 if no attempts found
  Future<double> _calculatePronunciationSessionAccuracy(int sessionId) async {
    // Get all session questions for this session
    final sessionQuestions = await _sessionQuestionDao.getQuestionsBySession(
      sessionId: sessionId,
    );

    if (sessionQuestions.isEmpty) return -1;

    final sessionQuestionIds = sessionQuestions.map((sq) => sq.id ?? 0).toList();

    // Get all attempts for these session questions
    final attempts = await _pronunciationAttemptDao
        .getAttemptsBySessionQuestionIds(
      sessionQuestionIds: sessionQuestionIds,
    );

    if (attempts.isEmpty) return -1;

    // Calculate accuracy: (correct attempts / total attempts) * 100
    final correctAttempts = attempts.where((a) => a.isCorrect).length;
    return (correctAttempts / attempts.length) * 100;
  }

  Future<List<RecentSession>> getRecentSessions({int limit = 10}) async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final students = await _studentDao.getAllStudents();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);

    completedSessions.sort(
      (a, b) => (b.endedAt ?? DateTime(0)).compareTo(a.endedAt ?? DateTime(0)),
    );

    final recentSessions = <RecentSession>[];

    for (final session in completedSessions.take(limit)) {
      final student = students.firstWhere(
        (s) => s.id == session.studentId,
        orElse: () => StudentTableData(
          id: 0,
          name: 'Unknown',
          firstName: '',
          lastName: '',
          gender: '',
          isSynced: false,
          syncedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      final game = games.firstWhere(
        (g) => g.id == session.gameId,
        orElse: () => GameTableData(
          id: 0,
          name: 'Unknown Game',
          description: '',
          category: '',
          route: '',
          isSynced: false,
          syncedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      // For pronunciation games, calculate score from attempts
      int score = session.score ?? 0;
      if (game.isPronunciationGame) {
        final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
          session.id ?? 0,
        );
        if (sessionAccuracy >= 0) {
          // Convert accuracy percentage to number of correct answers
          final totalQuestions = session.totalQuestions ?? 0;
          score = ((sessionAccuracy / 100) * totalQuestions).round();
        }
      }

      recentSessions.add(
        RecentSession(
          studentId: student.id.toString(),
          studentName: student.name,
          studentImage: student.image,
          gameId: game.id.toString(),
          gameName: game.name,
          score: score,
          totalQuestions: session.totalQuestions ?? 0,
          playedAt: session.endedAt ?? session.startedAt,
        ),
      );
    }

    return recentSessions;
  }

  Future<int> getTodayStudentCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final students = await _studentDao.getAllStudents();
    return students.where((s) => s.createdAt.isAfter(startOfDay)).length;
  }

  Future<int> getTodaySessionCount() async {
    final sessions = await _gameSessionDao.getTodayGameSessions();
    return sessions.length;
  }

  Future<int> getTodayPlayTimeMinutes() async {
    final sessions = await _gameSessionDao.getTodayGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    return completedSessions.fold(
          0,
          (sum, session) => sum + (session.durationSeconds ?? 0),
        ) ~/
        60;
  }

  Future<double> getTodayAverageAccuracy() async {
    final sessions = await _gameSessionDao.getTodayGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    if (completedSessions.isEmpty) return 0.0;

    int totalQuestions = 0;
    int totalCorrect = 0;

    for (final session in completedSessions) {
      final game = games.firstWhere(
        (g) => g.id == session.gameId,
        orElse: () => GameTableData(
          id: 0,
          name: 'Unknown',
          category: '',
          route: '',
          isSynced: false,
          syncedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );

      if (game.isPronunciationGame) {
        // For pronunciation games, calculate accuracy from attempts
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

    if (totalQuestions == 0) return 0.0;
    return (totalCorrect / totalQuestions) * 100;
  }

  // Phase 2 methods

  Future<List<StudentRanking>> getTopStudents({int limit = 5}) async {
    final students = await _studentDao.getAllStudents();
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);

    final studentRankings = <StudentRanking>[];

    for (final student in students) {
      final studentSessions = completedSessions.where((s) => s.studentId == student.id).toList();
      
      if (studentSessions.isEmpty) continue;

      double totalScore = 0;
      int totalQuestions = 0;

      for (final session in studentSessions) {
        final game = games.firstWhere(
          (g) => g.id == session.gameId,
          orElse: () => GameTableData(
            id: 0,
            name: 'Unknown',
            category: '',
            route: '',
            isSynced: false,
            syncedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        );

        if (game.isPronunciationGame) {
          // For pronunciation games, calculate score from attempts
          final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
            session.id ?? 0,
          );
          if (sessionAccuracy >= 0) {
            final sessionQuestions = session.totalQuestions ?? 0;
            totalScore += ((sessionAccuracy / 100) * sessionQuestions).round();
            totalQuestions += sessionQuestions;
          }
        } else {
          // For other games, use session score
          totalScore += session.score ?? 0;
          totalQuestions += session.totalQuestions ?? 0;
        }
      }

      final accuracy = totalQuestions > 0 ? (totalScore / totalQuestions) * 100 : 0.0;

      studentRankings.add(
        StudentRanking(
          studentId: student.id.toString(),
          studentName: student.name,
          studentImage: student.image,
          averageAccuracy: accuracy,
          totalSessions: studentSessions.length,
          rank: 0, // Will be set after sorting
        ),
      );
    }

    // Sort by accuracy descending
    studentRankings.sort((a, b) => b.averageAccuracy.compareTo(a.averageAccuracy));

    // Assign ranks
    for (var i = 0; i < studentRankings.length; i++) {
      studentRankings[i] = studentRankings[i].copyWith(rank: i + 1);
    }

    return studentRankings.take(limit).toList();
  }

  Future<List<DailyActivity>> getDailyActivity({int days = 7}) async {
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    final now = DateTime.now();
    final dailyActivity = <DailyActivity>[];

    for (var i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final daySessions = completedSessions.where((s) {
        final sessionDate = s.endedAt ?? s.startedAt;
        return sessionDate.isAfter(startOfDay) && sessionDate.isBefore(endOfDay);
      }).toList();

      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final dayName = dayNames[date.weekday - 1];

      dailyActivity.add(
        DailyActivity(
          date: startOfDay,
          dayName: dayName,
          sessionCount: daySessions.length,
        ),
      );
    }

    return dailyActivity;
  }

  Future<List<StudentRanking>> getLowPerformingStudents({int limit = 5}) async {
    final students = await _studentDao.getAllStudents();
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);

    final lowPerformers = <StudentRanking>[];

    for (final student in students) {
      final studentSessions = completedSessions.where((s) => s.studentId == student.id).toList();
      
      if (studentSessions.isEmpty) continue;

      double totalScore = 0;
      int totalQuestions = 0;

      for (final session in studentSessions) {
        final game = games.firstWhere(
          (g) => g.id == session.gameId,
          orElse: () => GameTableData(
            id: 0,
            name: 'Unknown',
            category: '',
            route: '',
            isSynced: false,
            syncedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        );

        if (game.isPronunciationGame) {
          // For pronunciation games, calculate score from attempts
          final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
            session.id ?? 0,
          );
          if (sessionAccuracy >= 0) {
            final sessionQuestions = session.totalQuestions ?? 0;
            totalScore += ((sessionAccuracy / 100) * sessionQuestions).round();
            totalQuestions += sessionQuestions;
          }
        } else {
          // For other games, use session score
          totalScore += session.score ?? 0;
          totalQuestions += session.totalQuestions ?? 0;
        }
      }

      final accuracy = totalQuestions > 0 ? (totalScore / totalQuestions) * 100 : 0.0;

      // Only include students with accuracy < 50%
      if (accuracy < 50) {
        lowPerformers.add(
          StudentRanking(
            studentId: student.id.toString(),
            studentName: student.name,
            studentImage: student.image,
            averageAccuracy: accuracy,
            totalSessions: studentSessions.length,
            rank: 0,
          ),
        );
      }
    }

    // Sort by accuracy ascending (lowest first)
    lowPerformers.sort((a, b) => a.averageAccuracy.compareTo(b.averageAccuracy));

    return lowPerformers.take(limit).toList();
  }

  Future<List<StudentRanking>> getInactiveStudents({int days = 7, int limit = 5}) async {
    final students = await _studentDao.getAllStudents();
    final sessions = await _gameSessionDao.getAllGameSessions();
    final games = await _gameDao.getAllGames();
    final completedSessions = await _filterCompletedSessions(sessions, games);
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));

    final inactiveStudents = <StudentRanking>[];

    for (final student in students) {
      final studentSessions = completedSessions.where((s) => s.studentId == student.id).toList();
      
      if (studentSessions.isEmpty) {
        // Never played - consider inactive
        inactiveStudents.add(
          StudentRanking(
            studentId: student.id.toString(),
            studentName: student.name,
            studentImage: student.image,
            averageAccuracy: 0.0,
            totalSessions: 0,
            rank: 0,
          ),
        );
        continue;
      }

      // Find last played date
      final lastSession = studentSessions.reduce((a, b) {
        final aDate = a.endedAt ?? a.startedAt;
        final bDate = b.endedAt ?? b.startedAt;
        return aDate.isAfter(bDate) ? a : b;
      });

      final lastPlayed = lastSession.endedAt ?? lastSession.startedAt;
      
      if (lastPlayed.isBefore(cutoffDate)) {
        double totalScore = 0;
        int totalQuestions = 0;

        for (final session in studentSessions) {
          final game = games.firstWhere(
            (g) => g.id == session.gameId,
            orElse: () => GameTableData(
              id: 0,
              name: 'Unknown',
              category: '',
              route: '',
              isSynced: false,
              syncedAt: DateTime.now(),
              createdAt: DateTime.now(),
            ),
          );

          if (game.isPronunciationGame) {
            // For pronunciation games, calculate score from attempts
            final sessionAccuracy = await _calculatePronunciationSessionAccuracy(
              session.id ?? 0,
            );
            if (sessionAccuracy >= 0) {
              final sessionQuestions = session.totalQuestions ?? 0;
              totalScore += ((sessionAccuracy / 100) * sessionQuestions).round();
              totalQuestions += sessionQuestions;
            }
          } else {
            // For other games, use session score
            totalScore += session.score ?? 0;
            totalQuestions += session.totalQuestions ?? 0;
          }
        }

        final accuracy = totalQuestions > 0 ? (totalScore / totalQuestions) * 100 : 0.0;

        inactiveStudents.add(
          StudentRanking(
            studentId: student.id.toString(),
            studentName: student.name,
            studentImage: student.image,
            averageAccuracy: accuracy,
            totalSessions: studentSessions.length,
            rank: 0,
          ),
        );
      }
    }

    return inactiveStudents.take(limit).toList();
  }

  /// Filter sessions to only include completed/played sessions
  /// Removes sessions where user entered and quit without playing
  Future<List<GameSessionTableData>> _filterCompletedSessions(
    List<GameSessionTableData> sessions,
    List<GameTableData> games,
  ) async {
    final completedSessions = <GameSessionTableData>[];

    for (final session in sessions) {
      // Skip sessions with no duration (user entered and quit immediately)
      if ((session.durationSeconds ?? 0) <= 0) {
        continue;
      }

      // For pronunciation games, also check if there are any attempts
      final game = games.firstWhere(
        (g) => g.id == session.gameId,
        orElse: () => GameTableData(
          id: 0,
          name: 'Unknown',
          category: '',
          route: '',
          isSynced: false,
          syncedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
      if (game.isPronunciationGame) {
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
}
