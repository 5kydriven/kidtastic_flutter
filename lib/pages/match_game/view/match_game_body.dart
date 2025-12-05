import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:kidtastic_flutter/extensions/string_extension.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class MatchGameBody extends StatelessWidget {
  final AnimationController animationController;
  final ConfettiController confettiController;
  final Animation<double> shake;

  const MatchGameBody({
    super.key,
    required this.animationController,
    required this.confettiController,
    required this.shake,
  });

  void _checkAnswer(BuildContext context, Question dropItem) {
    final bloc = context.read<MatchGameBloc>();
    final state = bloc.state;

    if (state.sessionQuestionRequestStatus == RequestStatus.inProgress) return;

    confettiController.kill();
    final currentShape = state.question[state.currentIndex];
    final isCorrect = dropItem.correctAnswer == currentShape.correctAnswer;

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

    if (!isCorrect) {
      animationController.forward(
        from: 0,
      );
    }

    bloc.add(
      MatchGameItemDropped(
        question: dropItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<MatchGameBloc, MatchGameState>(
      builder: (context, state) {
        if (state.screenRequestStatus != RequestStatus.success) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final current = state.question[state.currentIndex];

        final choices = (jsonDecode(current.choices ?? '[]') as List)
            .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 20,
          children: [
            // ================= LEFT DROP TARGET =================
            Expanded(
              child: SizedBox(
                height: size.height * 0.5,
                child: Card(
                  elevation: 12,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(52)),
                    side: BorderSide(
                      color: Color(0xff9FD10B),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        Text(
                          current.question?.capitalize() ?? '',
                          style: const TextStyle(
                            color: Color(0xffBC3740),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Expanded(
                          child: DragTarget<Question>(
                            onAcceptWithDetails: (details) =>
                                _checkAnswer(context, details.data),

                            builder: (context, candidateData, rejectedData) {
                              return AnimatedBuilder(
                                animation: animationController,
                                builder: (context, child) {
                                  // frequency controls how many back-and-forths during the animation
                                  const frequency =
                                      6; // tweak for faster/slower shake
                                  final offsetX =
                                      sin(
                                        animationController.value *
                                            pi *
                                            frequency,
                                      ) *
                                      shake.value;

                                  return Transform.translate(
                                    offset: Offset(offsetX, 0),
                                    child: child,
                                  );
                                },
                                child: state.droppedItem == null
                                    ? Image.asset(
                                        current.image ?? '',
                                        height: 200,
                                        width: 200,
                                      )
                                    : Image.asset(
                                        state.droppedItem?.image ?? '',
                                        height: 200,
                                        width: 200,
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ================= RIGHT DRAG ITEMS =================
            Expanded(
              child: SizedBox(
                height: size.height * 0.8,
                child: Card(
                  elevation: 12,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(52)),
                    side: BorderSide(
                      color: Color(0xff9FD10B),
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final itemWidth =
                                (constraints.maxWidth - 12) /
                                2; // 2 columns + spacing

                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(
                                choices.length,
                                (index) {
                                  final label = choices[index];

                                  return SizedBox(
                                    width: itemWidth,
                                    child: Center(
                                      child: Draggable<Question>(
                                        data: label,

                                        feedback: Image.asset(
                                          label.image ?? '',
                                          height: 150,
                                          width: 150,
                                        ),

                                        childWhenDragging: const Opacity(
                                          opacity: 0.3,
                                          child: SizedBox(),
                                        ),

                                        child: Image.asset(
                                          label.image ?? '',
                                          height: 150,
                                          width: 150,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
