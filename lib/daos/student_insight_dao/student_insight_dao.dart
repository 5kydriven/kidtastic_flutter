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

    const maxScorePerGame = 10;

    final totalSessions = sessions.length;
    final totalScore = sessions.fold<int>(0, (sum, s) => sum + (s.score ?? 0));

    final avgRawScore = totalScore / totalSessions;
    final avgPercentage = (avgRawScore / maxScorePerGame) * 100;

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
