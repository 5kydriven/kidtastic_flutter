import 'dart:convert';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/result/result.dart';

import '../bloc/bloc.dart';

class CountingGameBody extends StatelessWidget {
  const CountingGameBody({super.key});

  void _checkAnswer(BuildContext context, String selected) {
    final bloc = context.read<CountingGameBloc>();
    final state = bloc.state;
    final isCorrect =
        selected == state.question[state.currentIndex].correctAnswer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? '✅ Correct!' : '❌ Wrong answer!',
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(
          seconds: 1,
        ),
      ),
    );

    bloc.add(
      CountingGameButtonPressed(
        answer: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountingGameBloc, CountingGameState>(
      builder: (context, state) {
        if (state.screenRequestStatus == RequestStatus.success) {
          final current = state.question[state.currentIndex];
          final random = Random();
          final choices = List<String>.from(
            jsonDecode(current.choices ?? '[]'),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current.question ?? '',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    final imagePosition = List.generate(
                      int.parse(current.correctAnswer ?? '0'),
                      (_) => Offset(
                        random.nextDouble() * (size.width - 80),
                        random.nextDouble() * (size.height - 80),
                      ),
                    );

                    return Stack(
                      children: [
                        for (var pos in imagePosition)
                          Positioned(
                            left: pos.dx,
                            top: pos.dy,
                            child: Image.asset(
                              current.image ?? '',
                              width: 80,
                              height: 80,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: choices.map((choice) {
                  return OutlinedButton(
                    onPressed: () => _checkAnswer(context, choice),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      choice,
                      style: const TextStyle(
                        fontSize: 62,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
