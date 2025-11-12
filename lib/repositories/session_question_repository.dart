import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/session_question_dao/session_question_dao.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/models/models.dart';

class SessionQuestionRepository {
  final SessionQuestionDao _sessionQuestionDao;

  const SessionQuestionRepository({
    required SessionQuestionDao sessionQuestionDao,
  }) : _sessionQuestionDao = sessionQuestionDao;

  Future<Result<int>> addSessionQuestion({
    required SessionQuestion entry,
  }) async {
    try {
      final response = await _sessionQuestionDao.insertSessionQuestion(
        SessionQuestionTableCompanion.insert(
          sessionId: entry.sessionId ?? 0,
          questionId: entry.questionId ?? 0,
          studentAnswer: Value(entry.studentAnswer ?? ''),
          isCorrect: Value(entry.isCorrect ?? false),
        ),
      );
      return Result(
        data: response,
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result> getSessionQuestions({
    required int sessionId,
  }) async {
    try {
      final response = _sessionQuestionDao.getQuestionsBySession(
        sessionId: sessionId,
      );

      return Result(
        data: response,
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<SessionQuestion>> getQuestionId({required int id}) async {
    try {
      final response = await _sessionQuestionDao.getQuestionById(
        id: id,
      );

      return Result(
        data: SessionQuestion.fromJson(response.toJson()),
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result> updateSessionQuestion({
    required int sessionQuestionId,
    required String selectedAnswer,
    required bool isCorrect,
  }) async {
    try {
      await _sessionQuestionDao.updateSessionQuestion(
        sessionQuestionId: sessionQuestionId,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
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
}
