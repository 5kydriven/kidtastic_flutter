import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/teacher_table.dart';

part 'teacher_dao.g.dart';

@DriftAccessor(tables: [TeacherTable])
class TeacherDao extends DatabaseAccessor<KidtasticDatabase>
    with _$TeacherDaoMixin {
  TeacherDao(super.db);
}
