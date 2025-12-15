import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

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

  Future<Result<int>> signUp({
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      final result = await _teacherDao.insertTeacher(
        TeacherTableCompanion(
          name: Value(name),
          username: Value(username),
          password: Value(hashedPassword),
        ),
      );

      return Result(
        data: result,
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final result = await _teacherDao.getTeacherByUsername(username);

      final bool checkPassword = BCrypt.checkpw(password, result.password);

      if (!checkPassword) {
        return Result(
          statusCode: 401,
        );
      }

      return Result(
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }
}
