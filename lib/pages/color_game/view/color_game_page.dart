import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../color_game.dart';

class ColorGamePage extends StatefulWidget {
  static const route = '/color-game';
  final ColorGameState initialState;

  const ColorGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<ColorGamePage> createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
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
    ColorGameBloc bloc,
  ) {
    final state = bloc.state;
    bloc.add(const ColorGameSfxButtonPressed());
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
                bloc.add(const ColorGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const ColorGameSfxButtonPressed());
                if (state.currentIndex != 0) {
                  bloc.add(const ColorGameGameEnd());
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
    ColorGameState state,
  ) {
    final bloc = context.read<ColorGameBloc>();
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
                  bloc.add(const ColorGameSfxButtonPressed());
                  context.pop();
                  context.pop();
                },
                child: const Text('Choose another game'),
              ),
              TextButton(
                onPressed: () {
                  bloc.add(const ColorGameSfxButtonPressed());
                  bloc.add(const ColorGameScreenCreated());
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorGameBloc(
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
      )..add(const ColorGameScreenCreated()),
      child: BlocConsumer<ColorGameBloc, ColorGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
        builder: (context, state) {
          final bloc = context.read<ColorGameBloc>();
          final progress = state.question.isNotEmpty
              ? ((state.currentIndex + 1) / state.question.length).clamp(
                  0.0,
                  1.0,
                )
              : 0.0;

          return GameScaffold(
            imageAssets: Assets.colorBg,
            constraintsBox: 800,
            header: GameHeaderConfig(
              showBack: true,
              onBack: () => _confirmExit(context, bloc),
              showSettings: true,
              onSettings: () {
                bloc.add(const ColorGameSfxButtonPressed());
                showDialog(
                  context: context,
                  builder: (_) => SizedBox(
                    child: ColorGameSettingsDialog(
                      context: context,
                    ),
                  ),
                );
              },
              center: GameProgressBar(
                value: progress,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text('test'),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsetsGeometry.all(16),
                  child: Image.asset(
                    Assets.circleBrown,
                    width: 100,
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        Assets.circleBrown,
                        width: 70,
                      ),
                      Image.asset(
                        Assets.circleBrown,
                        width: 70,
                      ),
                      Image.asset(
                        Assets.circleBrown,
                        width: 70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // child: Card(
            //   elevation: 8,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 20,
            //       horizontal: 16,
            //     ),
            //     child: ColorGameBody(
            //       confettiController: _confettiController,
            //     ),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
