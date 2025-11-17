import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:kidtastic_flutter/pages/shape_game/widgets/shape_button.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class ShapeGameBody extends StatelessWidget {
  final ConfettiController confettiController;

  const ShapeGameBody({
    super.key,
    required this.confettiController,
  });

  void _checkAnswer(BuildContext context, String selected) {
    final bloc = context.read<ShapeGameBloc>();
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
      ShapeGameButtonPressed(
        answer: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ShapeGameBloc, ShapeGameState>(
      builder: (context, state) {
        if (state.screenRequestStatus == RequestStatus.success) {
          final current = state.question[state.currentIndex];
          final choices = List<String>.from(
            jsonDecode(current.choices ?? '[]'),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: size.height * 0.5,
                  child: Card(
                    elevation: 8,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(52)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            current.question ?? '',
                            style: TextStyle(
                              color: Color(0xffBC3740),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Image.asset(
                              current.image ?? '',
                              height: 200,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: size.height * 0.65,
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        padding: const EdgeInsets.all(12),
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: List.generate(
                          6,
                          (index) {
                            final label = index < choices.length
                                ? choices[index]
                                : '';
                            return ShapeButton(
                              label: label,
                              onPressed: () => _checkAnswer(context, label),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.13,
                      width: double.infinity,
                      child: Card(
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Score: ${state.score}',
                              style: const TextStyle(
                                fontSize: 32,
                                color: Color(0xffCF5961),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
