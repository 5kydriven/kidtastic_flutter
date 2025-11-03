import 'package:drift/drift.dart';

class StudentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get image => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get firstName => text().withLength(min: 1, max: 255)();
  TextColumn get lastName => text().withLength(min: 1, max: 255)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
