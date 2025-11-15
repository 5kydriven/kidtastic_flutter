import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/game_question_dao/game_question_dao.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/models/models.dart';

class GameQuestionRepository {
  final GameQuestionDao _gameQuestionDao;

  const GameQuestionRepository({
    required GameQuestionDao gameQuestionDao,
  }) : _gameQuestionDao = gameQuestionDao;

  Future<Result> addQuestion({
    required Question question,
  }) async {
    try {
      final data = await _gameQuestionDao.insertQuestion(
        GameQuestionTableCompanion.insert(
          gameId: question.gameId ?? 0,
          question: question.question ?? '',
          correctAnswer: question.correctAnswer ?? '',
          image: Value(question.image),
          difficulty: Value(question.difficulty?.name),
          audio: Value(question.audio),
          isSynced: Value(question.isSynced),
          choices: Value(question.choices),
        ),
      );
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

  Future<Result<List<Question>>> getQuestion({
    required int gameId,
    int limit = 5,
    bool isRandom = false,
    Difficulty difficulty = Difficulty.easy,
  }) async {
    try {
      final response = await _gameQuestionDao.getQuestionsForGame(
        gameId,
        difficulty,
      );
      if (isRandom) {
        response.shuffle();
      }

      return Result(
        data: response
            .map((e) => Question.fromJson(e.toJson()))
            .take(limit)
            .toList(),
        statusCode: 200,
      );
    } catch (e) {
      print('here: $e');
      return Result(
        statusCode: 400,
      );
    }
  }
}
