import 'package:kidtastic_flutter/daos/daos.dart';

import '../models/models.dart';

class TeacherRepository {
  final TeacherDao _teacherDao;

  const TeacherRepository({
    required TeacherDao teacherDao,
  }) : _teacherDao = teacherDao;

  Future<Result<Teacher>> getTeacher() async {
    try {
      final teacher = await _teacherDao.getSingleTeacher();

      if (teacher == null) {
        return Result(
          statusCode: 404,
        );
      }

      return Result(
        data: Teacher.fromJson(teacher.toJson()),
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }
}
