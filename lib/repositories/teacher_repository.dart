import 'package:kidtastic_flutter/daos/daos.dart';

class TeacherRepository {
  final TeacherDao _teacherDao;

  const TeacherRepository({
    required TeacherDao teacherDao,
  }) : _teacherDao = teacherDao;
}
