import 'package:kidtastic_flutter/daos/daos.dart';

class GameSessionRepository {
  final GameSessionDao _gameSessionDao;

  const GameSessionRepository({
    required GameSessionDao gameSessionDao,
  }) : _gameSessionDao = gameSessionDao;
}
