import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../models/models.dart';

class StudentRepository {
  final StudentDao _studentDao;

  const StudentRepository({
    required StudentDao studentDao,
  }) : _studentDao = studentDao;

  Future<Result> addStudent({
    required Student student,
  }) async {
    try {
      await _studentDao.insertStudent(
        StudentTableCompanion.insert(
          name: student.name ?? '',
          isSynced: Value(false),
          createdAt: Value(DateTime.now()),
          syncedAt: Value(DateTime.now()),
        ),
      );
      return Result(
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<List<Student>>> getStudents() async {
    try {
      final students = await _studentDao.getAllStudents();
      return Result(
        statusCode: 200,
        data: students.map((e) => Student.fromJson(e.toJson())).toList(),
      );
    } catch (e) {
      return Result(
        data: [],
        statusCode: 400,
      );
    }
  }

  Future<Result> deleteStudent({
    required int id,
  }) async {
    try {
      await _studentDao.destroyStudent(id);
      return Result(
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Stream<List<Student>> watchStudents() {
    return _studentDao.watchAll().map(
      (rows) => rows.map((e) => Student.fromJson(e.toJson())).toList(),
    );
  }
}
