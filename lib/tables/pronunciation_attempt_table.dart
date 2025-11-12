import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/tables/session_question_table.dart';

class PronunciationAttemptTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionQuestionId =>
      integer().references(SessionQuestionTable, #id)();
  TextColumn get word => text().nullable()();
  TextColumn get recognizedText => text().nullable()();
  RealColumn get confidence => real().withDefault(const Constant(0.0))();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();
  TextColumn get audioPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
