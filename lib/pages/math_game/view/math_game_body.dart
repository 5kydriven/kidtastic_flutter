import 'dart:math';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class MathGameBody extends StatefulWidget {
  const MathGameBody({super.key});

  @override
  State<MathGameBody> createState() => _MathGameBodyState();
}

class _MathGameBodyState extends State<MathGameBody> {
  final Random _random = Random();
  int _carrotCount = 0;
  late List<int> _choices;
  late int _correctAnswer;
  late List<Offset> _carrotPositions;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _carrotCount = _random.nextInt(5) + 1; // 1–5 carrots
    _correctAnswer = _carrotCount;

    // Random wrong choices
    final Set<int> options = {_correctAnswer};
    while (options.length < 3) {
      options.add(_random.nextInt(10) + 1);
    }

    _choices = options.toList()..shuffle();
    _carrotPositions = [];
  }

  void _generateCarrotPositions(Size size) {
    _carrotPositions = List.generate(
      _carrotCount,
      (_) => Offset(
        _random.nextDouble() * (size.width - 80),
        _random.nextDouble() * (size.height - 80),
      ),
    );
  }

  void _checkAnswer(int selected) {
    final isCorrect = selected == _correctAnswer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? '✅ Correct!' : '❌ Try again!',
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    if (isCorrect) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _generateQuestion());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many carrots are there?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Generate random positions within available area
                  _generateCarrotPositions(
                    Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                  );

                  return Stack(
                    children: [
                      for (var pos in _carrotPositions)
                        Positioned(
                          left: pos.dx,
                          top: pos.dy,
                          child: Image.asset(
                            Assets.carrot,
                            width: 80,
                            height: 80,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _choices
                  .map(
                    (choice) => OutlinedButton(
                      onPressed: () => _checkAnswer(choice),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 24,
                        ),
                      ),
                      child: Text(
                        '$choice',
                        style: const TextStyle(
                          fontSize: 62,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
