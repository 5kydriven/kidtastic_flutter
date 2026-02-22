import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:tracing_game/tracing_game.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class TracingGameBody extends StatelessWidget {
  final ConfettiController confettiController;
  const TracingGameBody({
    super.key,
    required this.confettiController,
  });

  List<TraceCharModel> _toTraceChars(String? value) {
    final safe = value ?? '';

    return safe
        .split('')
        .where((c) => RegExp(r'^[0-9]$').hasMatch(c))
        .map(
          (c) => TraceCharModel(
            char: c,
            traceShapeOptions: const TraceShapeOptions(
              innerPaintColor: Colors.orange,
            ),
          ),
        )
        .toList();
  }

  void _nextQuestion(BuildContext context) {
    final bloc = context.read<TracingGameBloc>();
    final state = bloc.state;

    if (state.sessionQuestionRequestStatus == RequestStatus.inProgress) return;

    confettiController.kill();

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

    bloc.add(const TracingGameTraceDone());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TracingGameBloc, TracingGameState>(
      builder: (context, state) {
        if (state.screenRequestStatus == RequestStatus.success) {
          final currentQuestion = state.question[state.currentIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trace the number ${currentQuestion.question?.toUpperCase()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: TracingCharsGame(
                  key: ValueKey(
                    'trace-session-${state.sessionStartTime?.millisecondsSinceEpoch ?? 0}',
                  ),
                  showAnchor: true,
                  onCurrentTracingScreenFinished: (index) async {
                    _nextQuestion(context);
                  },
                  onGameFinished: (int screenIndex) async {
                    _nextQuestion(context);
                  },
                  traceShapeModel: state.question
                      .map(
                        (item) => TraceCharsModel(
                          chars: _toTraceChars(item.correctAnswer),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
