import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class BubbleGameBody extends StatelessWidget {
  final ConfettiController confettiController;

  const BubbleGameBody({
    super.key,
    required this.confettiController,
  });

  void _checkAnswer(
    BuildContext context,
    String selected,
  ) {
    final bloc = context.read<BubbleGameBloc>();
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
      BubbleGameButtonPressed(
        answer: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleGameBloc, BubbleGameState>(
      builder: (context, state) {
        final bloc = context.read<BubbleGameBloc>();
        return Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final current = state.question[state.currentIndex];
              final choices = (jsonDecode(current.choices ?? '[]') as List)
                  .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
                  .toList();

              if (choices.isEmpty) {
                return const SizedBox.shrink();
              }

              if (state.imagePositions.isEmpty) {
                bloc.add(
                  BubbleGamePositionsGenerated(
                    questionIndex: state.currentIndex,
                    maxWidth: constraints.maxWidth,
                    maxHeight: constraints.maxHeight,
                  ),
                );
                return const SizedBox.shrink();
              }

              return Stack(
                clipBehavior: Clip.none,
                children: List.generate(choices.length, (index) {
                  final pos = state.imagePositions[index];
                  final choice = choices[index];

                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: FloatingImageButton(
                      onTap: () => _checkAnswer(
                        context,
                        choice.correctAnswer ?? '',
                      ),
                      child: Image.asset(
                        choice.image ?? '',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }
}
