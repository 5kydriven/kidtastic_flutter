import 'package:drift/drift.dart';

class GameTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().withLength(min: 1, max: 255)();
  TextColumn get imageAsset => text().nullable()();
  TextColumn get route => text().withLength(min: 1, max: 255)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
