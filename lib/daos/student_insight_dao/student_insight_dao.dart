import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/tables.dart';

part 'student_insight_dao.g.dart';

@DriftAccessor(
  tables: [
    StudentInsightTable,
    GameSessionTable,
  ],
)
class StudentInsightDao extends DatabaseAccessor<KidtasticDatabase>
    with _$StudentInsightDaoMixin {
  StudentInsightDao(super.db);

  Future<void> updateStudentInsight(int studentId, int gameId) async {
    final sessions =
        await (select(gameSessionTable)..where(
              (s) => s.studentId.equals(studentId) & s.gameId.equals(gameId),
            ))
            .get();

    if (sessions.isEmpty) return;

    final totalSessions = sessions.length;

    // Calculate percentage for each session using its totalQuestions
    double totalPercentage = 0;
    for (final session in sessions) {
      final score = session.score ?? 0;
      final totalQuestions = session.totalQuestions ?? 10; // Default to 10 if null
      final percentage = totalQuestions > 0
          ? (score / totalQuestions) * 100
          : 0;
      totalPercentage += percentage;
    }

    final avgPercentage = totalPercentage / totalSessions;

    final strength = avgPercentage >= 80
        ? 'Strong'
        : avgPercentage >= 50
        ? 'Average'
        : 'Needs Improvement';

    await into(studentInsightTable).insertOnConflictUpdate(
      StudentInsightTableCompanion(
        studentId: Value(studentId),
        gameId: Value(gameId),
        averageScore: Value(avgPercentage),
        totalSessions: Value(totalSessions),
        lastPlayed: Value(DateTime.now()),
        strength: Value(strength),
      ),
    );
  }

  Future<List<StudentInsightTableData>> getInsightsByStudent({
    required int studentId,
  }) => (select(
    studentInsightTable,
  )..where((i) => i.studentId.equals(studentId))).get();
}
