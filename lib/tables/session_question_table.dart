import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/tables/game_question_table.dart';
import 'package:kidtastic_flutter/tables/game_session_table.dart';

class SessionQuestionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(GameQuestionTable, #id)();
  IntColumn get questionId => integer().references(GameSessionTable, #id)();
  TextColumn get studentAnswer => text().nullable()();
  BoolColumn get isCorrext => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
