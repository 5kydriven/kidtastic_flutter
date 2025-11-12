import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/pronunciation_attempt_dao/pronunciation_attempt_dao.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../models/models.dart';

class PronunciationAttemptRepository {
  final PronunciationAttemptDao _pronunciationAttemptDao;

  const PronunciationAttemptRepository({
    required PronunciationAttemptDao pronunciationAttemptDao,
  }) : _pronunciationAttemptDao = pronunciationAttemptDao;

  Future<Result<int>> addAttempt({
    required PronunciationAttempt attempt,
  }) async {
    try {
      final id = await _pronunciationAttemptDao.insertAttempt(
        entry: PronunciationAttemptTableCompanion.insert(
          sessionQuestionId: attempt.sessionQuestionId ?? 0,
          word: Value(attempt.word),
          recognizedText: Value(attempt.recognizedText ?? ''),
          confidence: Value(attempt.confidence ?? 0.0),
          isCorrect: Value(attempt.isCorrect ?? false),
          audioPath: Value(attempt.audioPath ?? ''),
        ),
      );

      return Result(
        data: id,
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<List<PronunciationAttempt>>> getAttempts({
    required int sessionQuestionId,
  }) async {
    try {
      final response = await _pronunciationAttemptDao
          .getAttemptsBySessionQuestion(
            sessionQuestionId: sessionQuestionId,
          );

      final data = response
          .map((row) => PronunciationAttempt.fromJson(row.toJson()))
          .toList();

      return Result(
        data: data,
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result> deleteAttempts({
    required int sessionQuestionId,
  }) async {
    try {
      await _pronunciationAttemptDao.deleteAttemptsBySessionQuestion(
        sessionQuestionId: sessionQuestionId,
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
