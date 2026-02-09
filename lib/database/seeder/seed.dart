import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/pages/bubble_game/bubble_game.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/counting_game_page.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/view/pronunciation_game_page.dart';
import 'package:kidtastic_flutter/pages/shape_game/view/shape_game_page.dart';
import 'package:kidtastic_flutter/repositories/game_repository.dart';
import 'package:kidtastic_flutter/repositories/game_question_repository.dart';
import 'package:kidtastic_flutter/utils/pluralize_helper.dart';

import '../../models/models.dart';
import '../../pages/color_game/view/view.dart';

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

    log('🌱 Seeding initial games & questions... ');

    // --- Base Games ---
    final games = [
      Game(
        name: 'Counting',
        category: GameType.counting,
        description: 'Count how many picture you see!',
        imageAsset: Assets.numbersBtn,
        route: CountingGamePage.route,
      ),
      Game(
        name: 'Pronunciation',
        category: GameType.pronunciation,
        imageAsset: Assets.gamesBtn,
        description: 'Say the word correctly!',
        route: PronunciationGamePage.route,
      ),
      Game(
        name: 'Match the Shapes',
        category: GameType.matching,
        imageAsset: Assets.shapesBtn,
        description: 'Match shapes to learn geometry.',
        route: ShapeGamePage.route,
      ),
      Game(
        name: 'Bubble Letters',
        category: GameType.bubble,
        imageAsset: Assets.bubblePopBtn,
        description: 'Pop the bubble!',
        route: BubbleGamePage.route,
      ),
      Game(
        name: 'Learn your color',
        category: GameType.color,
        imageAsset: Assets.colorBg,
        description: 'Learn your color',
        route: ColorGamePage.route,
      ),
    ];

    final gameIds = <int>[];
    for (final game in games) {
      final result = await _gameRepository.addGame(
        game: game,
      );
      if (result.resultStatus == ResultStatus.error) {
        log('error $game');
      }
      gameIds.add(result.data ?? 0);
    }

    // --- Seed Questions ---
    await _seedCountingFruits(gameIds[0]);
    await _seedPronunciation(gameIds[1]);
    await _seedShapes(gameIds[2]);
    await _seedBubblePop(gameIds[3]);
    await _seedColors(gameIds[4]);
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

    const shapeCutouts = SeedData.shapeCutouts;
    const shapes = SeedData.shapes;

    for (final shapeCutout in shapeCutouts) {
      final correctShape = shapes.firstWhere(
        (s) => s.correctAnswer == shapeCutout.correctAnswer,
      );

      final wrongAnswers = shapes
          .where((s) => s.correctAnswer != correctShape.correctAnswer)
          .map((s) => s)
          .toList();
      wrongAnswers.shuffle(random);

      final choices = wrongAnswers.take(5).toList();
      choices.add(correctShape);
      choices.shuffle(random);

      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: shapeCutout.correctAnswer,
          correctAnswer: correctShape.correctAnswer,
          image: shapeCutout.image,
          difficulty: shapeCutout.difficulty,
          choices: jsonEncode(choices),
        ),
      );
    }
  }

  // ---------------------------
  // 🎨 COLOR GAME
  // ---------------------------
  Future<void> _seedColors(int gameId) async {
    final random = Random();

    const colorShapes = SeedData.colorShapes;

    for (final colorShape in colorShapes) {
      final correctAnswers = colorShapes.firstWhere(
        (s) => s.correctAnswer == colorShape.correctAnswer,
      );

      final wrongAnswers = colorShapes
          .where((s) => s.correctAnswer != colorShape.correctAnswer)
          .map((s) => s)
          .toList();
      wrongAnswers.shuffle(random);

      final choices = wrongAnswers.take(2).toList();
      choices.add(correctAnswers);
      choices.shuffle(random);

      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: colorShape.correctAnswer,
          correctAnswer: colorShape.correctAnswer,
          image: colorShape.image,
          difficulty: colorShape.difficulty,
          choices: jsonEncode(choices),
        ),
      );
    }
  }

  // ---------------------------
  // 🎨 Bubble Pop GAME
  // ---------------------------
  Future<void> _seedBubblePop(int gameId) async {
    final random = Random();
    final letters = SeedData.bubble;

    for (final letter in letters) {
      final correctLetter = letters.firstWhere(
        (s) => s.correctAnswer == letter.correctAnswer,
      );
      final wrongAnswers = letters
          .where((s) => s.correctAnswer != correctLetter.correctAnswer)
          .map((s) => s)
          .toList();
      wrongAnswers.shuffle(random);

      final choices = wrongAnswers.take(7).toList();
      choices.add(correctLetter);
      choices.shuffle(random);

      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: letter.question,
          correctAnswer: correctLetter.correctAnswer,
          difficulty: letter.difficulty,
          image: letter.image,
          choices: jsonEncode(choices),
        ),
      );
    }
  }
}
