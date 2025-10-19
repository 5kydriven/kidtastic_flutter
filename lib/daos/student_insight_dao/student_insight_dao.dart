import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/student_insight_table.dart';
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
    final totalScore = sessions.fold<int>(0, (sum, s) => sum + (s.score ?? 0));
    final avgScore = totalScore / totalSessions;

    final strength = avgScore >= 80 ? 'Strong' : 'Average';
    final weakness = avgScore < 50 ? 'Needs Improvement' : 'None';

    await into(studentInsightTable).insertOnConflictUpdate(
      StudentInsightTableCompanion.insert(
        studentId: studentId,
        gameId: gameId,
        averageScore: Value(avgScore),
        totalSessions: Value(totalSessions),
        lastPlayed: Value(DateTime.now()),
        strength: Value(strength),
        weakness: Value(weakness),
      ),
    );
  }

  Future<List<StudentInsightTableData>> getInsightsByStudent(int studentId) =>
      (select(
        studentInsightTable,
      )..where((i) => i.studentId.equals(studentId))).get();
}
