import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../../tables/tables.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [StudentTable])
class StudentDao extends DatabaseAccessor<KidtasticDatabase>
    with _$StudentDaoMixin {
  StudentDao(super.db);

  Future<int> insertStudent(StudentTableCompanion studentTableCompanion) async {
    return await into(studentTable).insert(studentTableCompanion);
  }

  Future<List<StudentTableData>> getAllStudents() async {
    return await select(studentTable).get();
  }

  Future<int> destroyStudent(int id) async {
    return await (delete(
      studentTable,
    )..where((student) => student.id.equals(id))).go();
  }

  Stream<List<StudentTableData>> watchAll() {
    return select(studentTable).watch();
  }
}
