import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/daos/daos.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../models/models.dart';

class GameRepository {
  final GameDao _gameDao;

  const GameRepository({
    required GameDao gameDao,
  }) : _gameDao = gameDao;

  Future<Result<List<Game>>> getGames() async {
    try {
      final response = await _gameDao.getAllGames();
      return Result(
        data: response.map((e) => Game.fromJson(e.toJson())).toList(),
        statusCode: 200,
      );
    } catch (e) {
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<int>> addGame({
    required Game game,
  }) async {
    try {
      final data = await _gameDao.insertGame(
        GameTableCompanion.insert(
          name: game.name ?? '',
          isSynced: Value(false),
          description: Value(game.description),
          category: game.category ?? '',
          imageAsset: Value(game.imageAsset),
          route: game.route ?? '',
        ),
      );
      return Result(
        data: data,
        statusCode: 200,
      );
    } catch (e) {
      print(e);
      return Result(
        statusCode: 400,
      );
    }
  }

  Future<Result<int>> destroyGame({required int id}) async {
    try {
      final response = await _gameDao.destroyGame(id);
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
}
