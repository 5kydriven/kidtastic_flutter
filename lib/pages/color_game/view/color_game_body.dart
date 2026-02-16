import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:kidtastic_flutter/widgets/hover_image_button.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class ColorGameBody extends StatelessWidget {
  final ConfettiController confettiController;

  const ColorGameBody({
    super.key,
    required this.confettiController,
  });

  void _checkAnswer(BuildContext context, String selected) {
    final bloc = context.read<ColorGameBloc>();
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
      ColorGameButtonPressed(
        answer: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorGameBloc, ColorGameState>(
      builder: (context, state) {
        final current = state.question.isNotEmpty
            ? state.question[state.currentIndex]
            : null;

        final choices = (jsonDecode(current?.choices ?? '[]') as List)
            .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (state.screenRequestStatus == RequestStatus.inProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Match the color of the shape below',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                current?.image ?? '',
                width: 142,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...choices.map(
                  (e) => HoverImageButton(
                    onTap: () => _checkAnswer(context, e.correctAnswer ?? ''),
                    child: Image.asset(
                      e.image ?? '',
                      width: 100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
