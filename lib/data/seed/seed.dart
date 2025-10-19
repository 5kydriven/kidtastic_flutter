import 'dart:math';
import 'package:kidtastic_flutter/constants/constants.dart';
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

    if (gameResult.data > 0) return;

    print('🌱 Seeding initial games & questions...');

    // --- Base Games ---
    final games = [
      Game(
        name: 'Counting Fruits',
        category: GameType.counting,
        description: 'Count how many fruits you see!',
      ),
      Game(
        name: 'Match the Shapes',
        category: GameType.matching,
        description: 'Match shapes to learn geometry.',
      ),
      Game(
        name: 'Color Guess',
        category: GameType.guessing,
        description: 'Guess what color this is!',
      ),
      Game(
        name: 'Pronunciation',
        category: GameType.pronunciation,
        description: 'Say the word correctly!',
      ),
    ];

    final gameIds = <int>[];
    for (final game in games) {
      final result = await _gameRepository.addGame(
        game: game,
      );
      gameIds.add(result.data);
    }

    // --- Seed Questions ---
    await _seedCountingFruits(gameIds[0]);
    await _seedShapes(gameIds[1]);
    await _seedColors(gameIds[2]);
    await _seedPronunciation(gameIds[3]);

    print('✅ Seeding complete!');
  }

  // ---------------------------
  // 🍎 COUNTING FRUITS GAME
  // ---------------------------
  Future<void> _seedCountingFruits(int gameId) async {
    const fruits = ['apple', 'banana', 'carrot', 'grape', 'orange'];
    final questions = <Question>[];

    for (final fruit in fruits) {
      final correctCount = _rng.nextInt(4) + 1; // 1–5 random
      final options = List.generate(4, (i) => (i + 1).toString());

      questions.add(
        Question(
          gameId: gameId,
          question: 'How many $fruit(s) are there?',
          correctAnswer: correctCount.toString(),
          options: options.toString(), // store as stringified list
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
          options: shapes.toString(),
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
          options: shuffled.toString(),
        ),
      );
    }
  }

  // ---------------------------
  // 🗣️ PRONUNCIATION GAME
  // ---------------------------
  Future<void> _seedPronunciation(int gameId) async {
    const words = ['Apple', 'Ball', 'Cat', 'Dog', 'Fish'];

    for (final w in words) {
      await _gameQuestionRepository.addQuestion(
        question: Question(
          gameId: gameId,
          question: 'Say the word: $w',
          correctAnswer: w,
          options: '{}', // not used
        ),
      );
    }
  }
}
