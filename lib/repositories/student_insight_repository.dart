import 'package:kidtastic_flutter/daos/student_insight_dao/student_insight_dao.dart';
import 'package:kidtastic_flutter/models/models.dart';

class StudentInsightRepository {
  final StudentInsightDao _studentInsightDao;

  const StudentInsightRepository({
    required StudentInsightDao studentInstightDao,
  }) : _studentInsightDao = studentInstightDao;

  Future<Result> updateStudentInsight({
    required int studentId,
    required int gameId,
  }) async {
    try {
      await _studentInsightDao.updateStudentInsight(studentId, gameId);
      return Result(
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<List<StudentInsight>>> getStudentInsight({
    required int studentId,
    required int gameId,
  }) async {
    try {
      final response = await _studentInsightDao.getInsightsByStudent(
        studentId: studentId,
      );

      return Result(
        data: response.map((e) => StudentInsight.fromJson(e.toJson())).toList(),
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }
}
