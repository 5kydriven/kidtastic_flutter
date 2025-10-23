import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/models/models.dart';

class GameSessionRepository {
  final GameSessionDao _gameSessionDao;

  const GameSessionRepository({
    required GameSessionDao gameSessionDao,
  }) : _gameSessionDao = gameSessionDao;

  Future<Result<int>> startSession({
    required int studentId,
    required int gameId,
  }) async {
    try {
      final sessionId = await _gameSessionDao.startSession(
        GameSessionTableCompanion.insert(
          studentId: studentId,
          gameId: gameId,
          startedAt: Value(DateTime.now()),
        ),
      );

      return Result(
        data: sessionId,
        statusCode: 200,
      );
    } catch (e) {
      print(e);
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result> endSession({
    required int sessionId,
    required int score,
  }) async {
    try {
      await _gameSessionDao.endSession(sessionId, score);

      return Result(
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<List<GameSession>>> getSessionsByStudent({
    required int studentId,
  }) async {
    try {
      final response = await _gameSessionDao.getSessionsByStudent(studentId);

      return Result(
        data: response.map((e) => GameSession.fromJson(e.toJson())).toList(),
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }
}
