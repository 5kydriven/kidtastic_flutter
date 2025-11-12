import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/session_question_table.dart';

part 'session_question_dao.g.dart';

@DriftAccessor(tables: [SessionQuestionTable])
class SessionQuestionDao extends DatabaseAccessor<KidtasticDatabase>
    with _$SessionQuestionDaoMixin {
  SessionQuestionDao(super.db);

  Future<int> insertSessionQuestion(SessionQuestionTableCompanion entry) async {
    return await into(sessionQuestionTable).insert(entry);
  }

  Future<List<SessionQuestionTableData>> getQuestionsBySession({
    required int sessionId,
  }) async {
    return await (select(
      sessionQuestionTable,
    )..where((question) => question.sessionId.equals(sessionId))).get();
  }

  Future<void> updateSessionQuestion({
    required int sessionQuestionId,
    required String selectedAnswer,
    required bool isCorrect,
  }) async {
    await (update(
      sessionQuestionTable,
    )..where((tbl) => tbl.id.equals(sessionQuestionId))).write(
      SessionQuestionTableCompanion(
        studentAnswer: Value(selectedAnswer),
        isCorrect: Value(isCorrect),
      ),
    );
  }

  Future<SessionQuestionTableData> getQuestionById({required int id}) async {
    return (select(
      sessionQuestionTable,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> deleteQuestionsBySession({
    required int sessionId,
  }) async {
    await (delete(
      sessionQuestionTable,
    )..where((tbl) => tbl.sessionId.equals(sessionId))).go();
  }
}
