import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/teacher_table.dart';

part 'teacher_dao.g.dart';

@DriftAccessor(
  tables: [TeacherTable],
)
class TeacherDao extends DatabaseAccessor<KidtasticDatabase>
    with _$TeacherDaoMixin {
  TeacherDao(super.db);

  Future<TeacherTableData?> getSingleTeacher() async {
    return await select(teacherTable).getSingleOrNull();
  }

  Future<int> insertTeacher(TeacherTableCompanion teacherTableCompanion) async {
    return await into(teacherTable).insert(teacherTableCompanion);
  }

  Future<TeacherTableData> getTeacherByUsername(String username) async {
    return await (select(
      teacherTable,
    )..where((teacher) => teacher.username.equals(username))).getSingle();
  }

  Future<int> updateTeacher({
    required int id,
    required TeacherTableCompanion data,
  }) async {
    return await (update(
      teacherTable,
    )..where((t) => t.id.equals(id))).write(data);
  }
}
