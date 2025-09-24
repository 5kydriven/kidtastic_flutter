import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../../tables/tables.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [StudentTable])
class StudentDao extends DatabaseAccessor<KidtasticDatabase>
    with _$StudentDaoMixin {
  StudentDao(super.db);

  Future<void> add(StudentTableCompanion studentTableCompanion) async {
    await into(studentTable).insert(studentTableCompanion);
  }

  Future<List<StudentTableData>> getAll() async {
    return await select(studentTable).get();
  }

  Future<void> destroy(int id) async {
    await (delete(studentTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<StudentTableData>> watchAll() {
    return select(studentTable).watch();
  }
}
