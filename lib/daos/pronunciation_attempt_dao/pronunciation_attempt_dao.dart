import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/pronunciation_attempt_table.dart';

part 'pronunciation_attempt_dao.g.dart';

@DriftAccessor(tables: [PronunciationAttemptTable])
class PronunciationAttemptDao extends DatabaseAccessor<KidtasticDatabase>
    with _$PronunciationAttemptDaoMixin {
  PronunciationAttemptDao(super.db);

  Future<int> insertAttempt({
    required PronunciationAttemptTableCompanion entry,
  }) async {
    return await into(pronunciationAttemptTable).insert(entry);
  }

  Future<List<PronunciationAttemptTableData>> getAttemptsBySessionQuestion({
    required int sessionQuestionId,
  }) async {
    return await (select(
      pronunciationAttemptTable,
    )..where((tbl) => tbl.sessionQuestionId.equals(sessionQuestionId))).get();
  }

  Future<void> deleteAttemptsBySessionQuestion({
    required int sessionQuestionId,
  }) async {
    await (delete(
      pronunciationAttemptTable,
    )..where((tbl) => tbl.sessionQuestionId.equals(sessionQuestionId))).go();
  }
}
