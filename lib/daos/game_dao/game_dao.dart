import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';

import '../../tables/tables.dart';

part 'game_dao.g.dart';

@DriftAccessor(tables: [GameTable])
class GameDao extends DatabaseAccessor<KidtasticDatabase> with _$GameDaoMixin {
  GameDao(super.db);

  Future<int> insertGame(GameTableCompanion gameTableCompanion) async {
    return await into(gameTable).insert(gameTableCompanion);
  }

  Future<List<GameTableData>> getAllGames() async {
    return await select(gameTable).get();
  }

  Future<bool> updateGame(GameTableCompanion gameTableCompanion) async {
    return await update(gameTable).replace(gameTableCompanion);
  }

  Future<int> destroyGame(int id) async {
    return await (delete(gameTable)..where((game) => game.id.equals(id))).go();
  }
}
