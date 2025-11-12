import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/tables/tables.dart';

class GameSessionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer().references(StudentTable, #id)();
  IntColumn get gameId => integer().references(GameTable, #id)();
  IntColumn get score => integer().nullable()();
  DateTimeColumn get startedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get endedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
