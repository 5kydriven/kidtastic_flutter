import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/tables/game_table.dart';
import 'package:kidtastic_flutter/tables/student_table.dart';

class StudentInsightTable extends Table {
  IntColumn get studentId => integer().references(StudentTable, #id)();
  IntColumn get gameId => integer().references(GameTable, #id)();
  RealColumn get averageScore => real().withDefault(const Constant(0.0))();
  IntColumn get totalSessions => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPlayed => dateTime().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get weakness => text().nullable()();

  @override
  Set<Column> get primaryKey => {studentId, gameId};
}
