import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../bubble_game.dart';

class BubbleGamePage extends StatefulWidget {
  static const route = '/bubble-game';
  final BubbleGameState initialState;

  const BubbleGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<BubbleGamePage> createState() => _BubbleGamePageState();
}

class _BubbleGamePageState extends State<BubbleGamePage> {
  late final ConfettiController _confettiController;

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

  void _confirmExit(
    BuildContext context,
    BubbleGameBloc bloc,
  ) {
    final state = bloc.state;
    bloc.add(const BubbleGameSfxButtonPressed());
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
                bloc.add(const BubbleGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const BubbleGameSfxButtonPressed());
                if (state.currentIndex != 0) {
                  bloc.add(const BubbleGameGameEnd());
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

  void _gameListener(
    BuildContext context,
    BubbleGameState state,
  ) {
    final bloc = context.read<BubbleGameBloc>();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Your score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${state.score}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                  bloc.add(const BubbleGameSfxButtonPressed());
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
                  bloc.add(const BubbleGameSfxButtonPressed());
                  bloc.add(const BubbleGameScreenCreated());
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BubbleGameBloc(
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
      )..add(const BubbleGameScreenCreated()),
      child: BlocListener<BubbleGameBloc, BubbleGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
        child: BlocBuilder<BubbleGameBloc, BubbleGameState>(
          builder: (context, state) {
            final bloc = context.read<BubbleGameBloc>();
            final progress = state.question.isNotEmpty
                ? ((state.currentIndex + 1) / state.question.length).clamp(
                    0.0,
                    1.0,
                  )
                : 0.0;

            return GameScaffold(
              constraintsBox: 800,
              header: GameHeaderConfig(
                showBack: true,
                onBack: () => _confirmExit(context, bloc),
                showSettings: true,
                onSettings: () {
                  bloc.add(const BubbleGameSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: BubbleGameSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
                center: GameProgressBar(
                  value: progress,
                ),
              ),
              imageAssets: Assets.bubbleBg,
              child: Builder(
                builder: (context) {
                  if (state.screenRequestStatus == RequestStatus.success) {
                    return Column(
                      children: [
                        BubbleGameBody(
                          confettiController: _confettiController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BubbleGameBtb(),
                        ),
                      ],
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
