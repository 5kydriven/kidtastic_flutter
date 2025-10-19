import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/game_table.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [GameTable])
class GameDao extends DatabaseAccessor<KidtasticDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  Future<int> insertGame(GameTableCompanion game) async {
    return await into(gameTable).insert(game);
  }

  Future<List<GameTableData>> getAllGames() async {
    return await select(gameTable).get();
  }

  Future<bool> updateGame(GameTableCompanion game) async {
    return await update(gameTable).replace(game);
  }

  Future<int> destroyGame(int id) async {
    return await (delete(gameTable)..where((game) => game.id.equals(id))).go();
  }
}
