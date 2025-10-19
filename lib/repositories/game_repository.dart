import 'package:kidtastic_flutter/daos/daos.dart';

class GameRepository {
  final GameDao _gameDao;

  const GameRepository({
    required GameDao gameDao,
  }) : _gameDao = gameDao;
}
