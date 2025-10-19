import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../models/models.dart';

class GameRepository {
  final GameDao _gameDao;

  const GameRepository({
    required GameDao gameDao,
  }) : _gameDao = gameDao;

  Future<Result> getGames() async {
    try {
      final data = _gameDao.getAllGames();
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

  Future<Result> addGame({required Game game}) async {
    try {
      final data = await _gameDao.insertGame(
        GameTableCompanion.insert(
          name: game.name ?? '',
          isSynced: Value(false),
          description: Value(game.description),
          category: game.category ?? '',
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
}
