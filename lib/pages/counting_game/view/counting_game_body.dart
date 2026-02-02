import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:kidtastic_flutter/models/result/result.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/view.dart';

import '../bloc/bloc.dart';

class CountingGameBody extends StatelessWidget {
  final ConfettiController confettiController;

  const CountingGameBody({
    super.key,
    required this.confettiController,
  });

  void _checkAnswer(BuildContext context, String selected) {
    final bloc = context.read<CountingGameBloc>();
    final state = bloc.state;

    if (state.sessionQuestionRequestStatus == RequestStatus.inProgress) return;

    confettiController.kill();
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
          milliseconds: 2500,
        ),
      ),
    );

    if (isCorrect) {
      Confetti.launch(
        context,
        options: ConfettiOptions(
          particleCount: 250,
          spread: 275,
          gravity: 3,
          colors: [
            Color(0xFFC8C8FF),
            Color(0xFFC8EFFF),
            Color(0xFFBBEEE9),
          ],
        ),
      );
    }

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
        final bloc = context.read<CountingGameBloc>();
        if (state.screenRequestStatus == RequestStatus.success) {
          final current = state.question[state.currentIndex];
          final choices = List<String>.from(
            jsonDecode(current.choices ?? '[]'),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key: countingQuestionKey,
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
                key: countingContentsKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (state.imagePositions.isEmpty) {
                      bloc.add(
                        CountingGamePositionsGenerated(
                          questionIndex: state.currentIndex,
                          maxWidth: constraints.maxWidth,
                          maxHeight: constraints.maxHeight,
                        ),
                      );
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (final pos in state.imagePositions)
                          Positioned(
                            left: pos.dx,
                            top: pos.dy,
                            child: Image.asset(
                              state.question[state.currentIndex].image ?? '',
                              width: 120,
                              height: 120,
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
                key: countingButtonsKey,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: choices.map((choice) {
                  return OutlinedButton(
                    onPressed: () => _checkAnswer(context, choice),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
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
