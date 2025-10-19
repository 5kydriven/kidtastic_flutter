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
}
