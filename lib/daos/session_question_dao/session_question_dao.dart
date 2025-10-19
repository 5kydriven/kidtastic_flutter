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

  Future<List<SessionQuestionTableData>> getQuestionsBySession(
    int sessionId,
  ) async {
    return await (select(
      sessionQuestionTable,
    )..where((question) => question.sessionId.equals(sessionId))).get();
  }
}
