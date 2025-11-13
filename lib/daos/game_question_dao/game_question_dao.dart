import 'package:drift/drift.dart';
import 'package:kidtastic_flutter/database/kidtastic_database.dart';
import 'package:kidtastic_flutter/tables/game_question_table.dart';

part 'game_question_dao.g.dart';

@DriftAccessor(tables: [GameQuestionTable])
class GameQuestionDao extends DatabaseAccessor<KidtasticDatabase>
    with _$GameQuestionDaoMixin {
  GameQuestionDao(super.db);

  Future<int> insertQuestion(
    GameQuestionTableCompanion question,
  ) async {
    return into(gameQuestionTable).insert(question);
  }

  Future<int> destroyQuestion(int id) async {
    return await (delete(
      gameQuestionTable,
    )..where((question) => question.id.equals(id))).go();
  }

  Future<List<GameQuestionTableData>> getQuestionsForGame(
    int gameId,
    String difficulty,
  ) async {
    return await (select(gameQuestionTable)..where(
          (question) =>
              question.gameId.equals(gameId) &
              question.difficulty.equals(difficulty),
        ))
        .get();
  }
}
