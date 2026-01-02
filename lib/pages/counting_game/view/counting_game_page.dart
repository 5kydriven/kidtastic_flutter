import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/view.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';

class CountingGamePage extends StatefulWidget {
  static const route = '/counting_game';
  final CountingGameState initialState;

  const CountingGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<CountingGamePage> createState() => _CountingGamePageState();
}

class _CountingGamePageState extends State<CountingGamePage> {
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

  void _gameListener(
    BuildContext context,
    CountingGameState state,
  ) {
    final bloc = context.read<CountingGameBloc>();
    if (state.hasEnded) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text(
              'Your score is ${state.score}',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: const Text('Choose another game'),
              ),
              TextButton(
                onPressed: () {
                  bloc.add(const CountingGameScreenCreated());
                  context.pop();
                },
                child: const Text('Play again'),
              ),
            ],
          );
        },
      );
    }
  }

  void _confirmExit(BuildContext context, CountingGameBloc bloc) {
    final state = bloc.state;
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
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (state.currentIndex != 0) {
                  bloc.add(const CountingGameGameEnd());
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountingGameBloc(
        initialState: widget.initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(
              context,
            ),
      )..add(const CountingGameScreenCreated()),
      child: BlocListener<CountingGameBloc, CountingGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,

        child: BlocBuilder<CountingGameBloc, CountingGameState>(
          builder: (context, state) {
            final bloc = context.read<CountingGameBloc>();
            final progress = state.question.isNotEmpty
                ? ((state.currentIndex + 1) / state.question.length).clamp(
                    0.0,
                    1.0,
                  )
                : 0.0;

            return GameScaffold(
              imageAssets: Assets.mathBg,
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () => _confirmExit(context, bloc),
                onSettings: () => showDialog(
                  context: context,
                  builder: (_) => SizedBox(
                    child: CountingGameSettingsDialog(
                      context: context,
                    ),
                  ),
                ),
                center: GameProgressBar(
                  value: progress,
                ),
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: CountingGameBody(
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
