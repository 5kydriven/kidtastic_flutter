import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/tables/game_table.dart';

class GameQuestionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(GameTable, #id)();
  TextColumn get question => text().withLength(min: 1, max: 255)();
  TextColumn get difficulty => text().withLength(min: 1, max: 255)();
  TextColumn get correctAnswer => text().withLength(min: 1, max: 255)();
  TextColumn get image => text().nullable()();
  TextColumn get audio => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
