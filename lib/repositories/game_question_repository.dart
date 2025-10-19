import 'package:kidtastic_flutter/daos/game_question_dao/game_question_dao.dart';

class GameQuestionRepository {
  final GameQuestionDao _gameQuestionDao;

  const GameQuestionRepository({
    required GameQuestionDao gameQuestionDao,
  }) : _gameQuestionDao = gameQuestionDao;
}
