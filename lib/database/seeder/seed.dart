import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/counting_game_page.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/view/pronunciation_game_page.dart';
import 'package:kidtastic_flutter/repositories/game_repository.dart';
import 'package:kidtastic_flutter/repositories/game_question_repository.dart';

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
        category: GameType.matching,
        imageAsset: Assets.shapes,
        description: 'Match shapes to learn geometry.',
        route: '/shapes-game',
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
    // await _seedShapes(gameIds[1]);
    // await _seedColors(gameIds[2]);

    print('✅ Seeding complete!');
  }

  // ---------------------------
  // 🍎 COUNTING FRUITS GAME
  // ---------------------------
  Future<void> _seedCountingFruits(int gameId) async {
    final fruits = <Fruit>[
      Fruit(
        name: 'chili pepper',
        image: Assets.chiliPepper,
      ),
      Fruit(
        name: 'apple',
        image: Assets.apple,
      ),
      Fruit(
        name: 'carrot',
        image: Assets.carrot,
      ),
      Fruit(
        name: 'pear',
        image: Assets.pear,
      ),
      Fruit(
        name: 'strawberry',
        image: Assets.strawberry,
      ),
    ];

    final questions = <Question>[];

    for (int i = 0; i < 20; i++) {
      final fruit = fruits[_rng.nextInt(fruits.length)];
      final correctCount = _rng.nextInt(9) + 1;

      final allOptions = <int>{correctCount};
      while (allOptions.length < 3) {
        allOptions.add(_rng.nextInt(9) + 1);
      }

      final options = allOptions.map((n) => n.toString()).toList()..shuffle();

      questions.add(
        Question(
          gameId: gameId,
          question: 'How many ${fruit.name}s are there?',
          correctAnswer: correctCount.toString(),
          image: fruit.image,
          choices: jsonEncode(options),
        ),
      );
    }

    for (final question in questions) {
      await _gameQuestionRepository.addQuestion(
        question: question,
      );
    }

    log('counting seeded');
  }

  // ---------------------------
  // 🗣️ PRONUNCIATION GAME
  // ---------------------------
  Future<void> _seedPronunciation(int gameId) async {
    const words = <Question>[
      Question(
        question: 'Fox wearing a necktie',
        image: Assets.foxWearingNecktie,
      ),
      Question(
        question: 'Bird feeding worm',
        image: Assets.birdFeedingWorm,
      ),
      Question(
        question: 'Rabbit with ball',
        image: Assets.rabbitWithBall,
      ),
      Question(
        question: 'There are two giraffes.',
        image: Assets.giraffe,
      ),
      Question(
        question: 'There is an aligator.',
        image: Assets.aligator,
      ),
    ];

    for (final word in words) {
      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: word.question,
          correctAnswer: word.question,
          image: word.image,
        ),
      );
    }
  }

  // ---------------------------
  // 🔺 MATCH THE SHAPES GAME
  // ---------------------------
  Future<void> _seedShapes(int gameId) async {
    const shapes = ['circle', 'square', 'triangle', 'rectangle'];
    for (final s in shapes) {
      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: 'Which shape matches a $s?',
          correctAnswer: s,
          choices: shapes.toString(),
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
