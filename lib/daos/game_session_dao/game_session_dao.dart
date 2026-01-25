import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/game_session_table.dart';

part 'game_session_dao.g.dart';

@DriftAccessor(tables: [GameSessionTable])
class GameSessionDao extends DatabaseAccessor<KidtasticDatabase>
    with _$GameSessionDaoMixin {
  GameSessionDao(super.db);

  Future<int> startSession(GameSessionTableCompanion session) async {
    return await into(gameSessionTable).insert(session);
  }

  Future<void> endSession(int sessionId, int score) async {
    await (update(
      gameSessionTable,
    )..where((student) => student.id.equals(sessionId))).write(
      GameSessionTableCompanion(
        score: Value(score),
        endedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<GameSessionTableData>> getSessionsByStudent(int studentId) async {
    return await (select(
      gameSessionTable,
    )..where((student) => student.studentId.equals(studentId))).get();
  }

  Future<List<GameSessionTableData>> getAllGameSessions() async {
    return await select(gameSessionTable).get();
  }

  Future<List<GameSessionTableData>> getTodayGameSessions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(gameSessionTable)..where(
          (tbl) =>
              tbl.startedAt.isBiggerOrEqualValue(startOfDay) &
              tbl.startedAt.isSmallerThanValue(endOfDay),
        ))
        .get();
  }

  Future<DateTime?> getLastPlayedForStudent(int studentId) async {
    final result =
        await (selectOnly(gameSessionTable)
              ..addColumns([gameSessionTable.endedAt])
              ..where(gameSessionTable.studentId.equals(studentId))
              ..orderBy([
                OrderingTerm(
                  expression: gameSessionTable.endedAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    return result?.read(gameSessionTable.endedAt);
  }
}
