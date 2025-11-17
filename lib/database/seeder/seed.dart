import 'dart:convert';
import 'dart:math' hide log;

import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/counting_game_page.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/view/pronunciation_game_page.dart';
import 'package:kidtastic_flutter/pages/shape_game/view/shape_game_page.dart';
import 'package:kidtastic_flutter/repositories/game_repository.dart';
import 'package:kidtastic_flutter/repositories/game_question_repository.dart';
import 'package:kidtastic_flutter/utils/pluralize_helper.dart';

import '../../models/models.dart';

class InitialDataSeeder {
  final GameRepository _gameRepository;
  final GameQuestionRepository _gameQuestionRepository;
  final _rng = Random();

  InitialDataSeeder({
    required GameRepository gameRepository,
    required GameQuestionRepository gameQuestionRepository,
  }) : _gameQuestionRepository = gameQuestionRepository,
       _gameRepository = gameRepository;

  /// 🌱 Run this once on first app launch
  Future<void> seed() async {
    final gameResult = await _gameRepository.getGames();

    // log(gameResult.data.toString());
    if ((gameResult.data ?? []).isNotEmpty) return;

    print('🌱 Seeding initial games & questions... ');

    // --- Base Games ---
    final games = [
      Game(
        name: 'Counting',
        category: GameType.counting,
        description: 'Count how many picture you see!',
        imageAsset: Assets.letters,
        route: CountingGamePage.route,
      ),
      Game(
        name: 'Pronunciation',
        category: GameType.pronunciation,
        imageAsset: Assets.musicNotes,
        description: 'Say the word correctly!',
        route: PronunciationGamePage.route,
      ),
      Game(
        name: 'Match the Shapes',
        category: GameType.shape,
        imageAsset: Assets.shapes,
        description: 'Match shapes to learn geometry.',
        route: ShapeGamePage.route,
      ),
    ];

    final gameIds = <int>[];
    for (final game in games) {
      final result = await _gameRepository.addGame(
        game: game,
      );
      if (result.resultStatus == ResultStatus.error) {
        print('error $game');
      }
      gameIds.add(result.data ?? 0);
    }

    // --- Seed Questions ---
    await _seedCountingFruits(gameIds[0]);
    await _seedPronunciation(gameIds[1]);
    await _seedShapes(gameIds[2]);
    // await _seedColors(gameIds[2]);
  }

  // ---------------------------
  // 🍎 COUNTING FRUITS GAME
  // ---------------------------
  Future<void> _seedCountingFruits(int gameId) async {
    final fruits = SeedData.fruits;

    final questions = <Question>[];

    for (int i = 0; i < 20; i++) {
      final fruit = fruits[_rng.nextInt(fruits.length)];
      final correctCount = _rng.nextInt(9) + 1;

      final allOptions = <int>{correctCount};
      while (allOptions.length < 3) {
        allOptions.add(_rng.nextInt(9) + 1);
      }

      final options = allOptions.map((n) => n.toString()).toList()..shuffle();
      final fruitName = pluralizeFruit(
        name: fruit.name ?? '',
        count: correctCount,
      );

      questions.add(
        Question(
          gameId: gameId,
          question: 'How many $fruitName are there?',
          correctAnswer: correctCount.toString(),
          image: fruit.image,
          difficulty: Difficulty.easy,
          choices: jsonEncode(options),
        ),
      );
    }

    for (final question in questions) {
      await _gameQuestionRepository.addQuestion(
        question: question,
      );
    }
  }

  // ---------------------------
  // 🗣️ PRONUNCIATION GAME
  // ---------------------------
  Future<void> _seedPronunciation(int gameId) async {
    const words = SeedData.words;

    for (final word in words) {
      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: word.question,
          correctAnswer: word.question,
          difficulty: word.difficulty,
          image: word.image,
        ),
      );
    }
  }

  // ---------------------------
  // 🔺 MATCH THE SHAPES GAME
  // ---------------------------
  Future<void> _seedShapes(int gameId) async {
    final random = Random();

    const shapes = SeedData.shapes;

    for (final shape in shapes) {
      final otherAnswers = shapes
          .where((s) => s.correctAnswer != shape.correctAnswer)
          .map((s) => s.correctAnswer)
          .toList();

      otherAnswers.shuffle(random);
      final randomChoices = otherAnswers.take(5).toList();

      randomChoices.add(shape.correctAnswer);
      randomChoices.shuffle(random);

      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: 'What shape is this?',
          correctAnswer: shape.correctAnswer,
          image: shape.image,
          difficulty: shape.difficulty,
          choices: jsonEncode(randomChoices),
        ),
      );
    }
  }

  // ---------------------------
  // 🎨 COLOR GUESS GAME
  // ---------------------------
  Future<void> _seedColors(int gameId) async {
    const colorQuestions = [
      {'question': 'What color is the sky?', 'answer': 'Blue'},
      {'question': 'What color is the grass?', 'answer': 'Green'},
      {'question': 'What color is a banana?', 'answer': 'Yellow'},
      {'question': 'What color is an apple?', 'answer': 'Red'},
    ];

    for (final c in colorQuestions) {
      final shuffled = ['Red', 'Green', 'Blue', 'Yellow']..shuffle(_rng);
      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: c['question']!,
          correctAnswer: c['answer']!,
          choices: shuffled.toString(),
        ),
      );
    }
  }
}
