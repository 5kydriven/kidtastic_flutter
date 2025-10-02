import 'dart:math';
import 'package:flutter/material.dart';

class NumberGamePage extends StatefulWidget {
  static const route = '/number-game';
  const NumberGamePage({super.key});

  @override
  State<NumberGamePage> createState() => _NumberGamePageState();
}

class _NumberGamePageState extends State<NumberGamePage> {
  final Random _random = Random();
  int _stage = 1;
  int _score = 0;

  late String _question;
  late String _item;
  late int _answer;
  late List<int> _choices;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final items = ['carrots', 'oranges'];
    _item = items[_random.nextInt(items.length)];
    _answer = _random.nextInt(5) + 1; // between 1 and 5
    _question = 'How many $_item are there?';

    // Generate 3 random choices (including correct answer)
    Set<int> choices = {_answer};
    while (choices.length < 3) {
      choices.add(_random.nextInt(5) + 1);
    }
    _choices = choices.toList()..shuffle();
  }

  void _checkAnswer(int choice) {
    if (choice == _answer) {
      _score++;
    }
    if (_stage < 5) {
      setState(() {
        _stage++;
        _generateQuestion();
      });
    } else {
      _showGameOver();
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: $_score / 5'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _stage = 1;
                _score = 0;
                _generateQuestion();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Icon _buildIcon() {
    if (_item == 'carrots') {
      return const Icon(Icons.restaurant, size: 48, color: Colors.orange);
    } else {
      return const Icon(Icons.circle, size: 48, color: Colors.deepOrange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stage $_stage / 5'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _question,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // show icons so kids can count them
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_answer, (index) => _buildIcon()),
            ),

            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              children: _choices.map((choice) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(choice),
                  child: Text(
                    choice.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
