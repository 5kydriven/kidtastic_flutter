import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../tracing_game.dart';

class TracingGamePage extends StatefulWidget {
  static const route = '/tracing-game';
  final TracingGameState initialState;

  const TracingGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<TracingGamePage> createState() => _TracingGamePageState();
}

class _TracingGamePageState extends State<TracingGamePage> {
  late final ConfettiController _confettiController;

  void _gameListener(
    BuildContext context,
    TracingGameState state,
  ) {
    final bloc = context.read<TracingGameBloc>();
    if (state.hasEnded) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            title: const Center(
              child: Text(
                'Game Over',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Amazing work! You finished tracing every number!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowDirection: VerticalDirection.up,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  bloc.add(const TracingGameSfxButtonPressed());
                  context.pop();
                  context.pop();
                },
                child: const Text(
                  'Choose another game',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  bloc.add(const TracingGameSfxButtonPressed());
                  bloc.add(const TracingGameScreenCreated());
                  context.pop();
                },
                child: const Text(
                  'Play again',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _confirmExit(BuildContext context, TracingGameBloc bloc) {
    final state = bloc.state;
    bloc.add(const TracingGameSfxButtonPressed());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Game'),
          content: const Text(
            'Are you sure you want to exit the game?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                bloc.add(const TracingGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const TracingGameSfxButtonPressed());
                if (state.currentIndex != 0) {
                  bloc.add(const TracingGameGameEnd());
                }
                context.pop();
                context.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
  }

  @override
  void dispose() {
    _confettiController.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracingGameBloc(
        initialState: widget.initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(context),
        studentInsightRepository:
            RepositoryProvider.of<StudentInsightRepository>(context),
      )..add(const TracingGameScreenCreated()),
      child: BlocListener<TracingGameBloc, TracingGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
        child: BlocBuilder<TracingGameBloc, TracingGameState>(
          builder: (context, state) {
            final bloc = context.read<TracingGameBloc>();
            final progress = state.question.isNotEmpty
                ? ((state.currentIndex + 1) / state.question.length).clamp(
                    0.0,
                    1.0,
                  )
                : 0.0;

            return GameScaffold(
              imageAssets: Assets.traceBgOne,
              constraintsBox: 800,
              header: GameHeaderConfig(
                showBack: true,
                onBack: () => _confirmExit(context, bloc),
                showSettings: true,
                onSettings: () {
                  bloc.add(const TracingGameSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: TracingGameSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
                center: GameProgressBar(
                  value: progress,
                ),
              ),
              child: Card(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: TracingGameBody(
                    confettiController: _confettiController,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
