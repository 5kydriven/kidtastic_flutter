import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';
import 'view.dart';

class PronunciationGamePage extends StatefulWidget {
  static const String route = '/pronunciation-game';
  final PronunciationGameState initialState;

  const PronunciationGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<PronunciationGamePage> createState() => _PronunciationGamePageState();
}

class _PronunciationGamePageState extends State<PronunciationGamePage> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController();
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.kill();
    super.dispose();
  }

  void _gameListener(BuildContext context, PronunciationGameState state) {
    final bloc = context.read<PronunciationGameBloc>();
    if (!state.isGameEnded) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
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
                context.pop();
                bloc.add(const PronunciationGameScreenCreated());
              },
              child: const Text('Play again'),
            ),
          ],
        );
      },
    );
  }

  void _correctRecordListener(
    BuildContext context,
    PronunciationGameState state,
  ) {
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

  void _confirmExit(BuildContext context, PronunciationGameBloc bloc) {
    final state = bloc.state;
    bloc.add(const PronunciationGameSfxButtonPressed());
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
                bloc.add(const PronunciationGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const PronunciationGameSfxButtonPressed());
                if (state.currentIndex != 0) {
                  bloc.add(const PronunciationGameGameEnd());
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
      create: (context) => PronunciationGameBloc(
        initialState: widget.initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(context),
        pronunciationAttemptRepository:
            RepositoryProvider.of<PronunciationAttemptRepository>(context),
      )..add(const PronunciationGameScreenCreated()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PronunciationGameBloc, PronunciationGameState>(
            listener: _gameListener,
            listenWhen: (previous, current) =>
                previous.gameSessionRequestStatus !=
                    current.gameSessionRequestStatus &&
                current.gameSessionRequestStatus == RequestStatus.success,
          ),
          BlocListener<PronunciationGameBloc, PronunciationGameState>(
            listener: _correctRecordListener,
            listenWhen: (previous, current) =>
                previous.pronunciationRequestStatus !=
                    current.pronunciationRequestStatus &&
                current.isCorrect,
          ),
        ],
        child: BlocBuilder<PronunciationGameBloc, PronunciationGameState>(
          builder: (context, state) {
            final bloc = context.read<PronunciationGameBloc>();
            final progress = state.question.isNotEmpty
                ? ((state.currentIndex + 1) / state.question.length).clamp(
                    0.0,
                    1.0,
                  )
                : 0.0;
            return GameScaffold(
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () => _confirmExit(context, bloc),
                onSettings: () {
                  bloc.add(const PronunciationGameSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: PronunciationGameSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
                center: GameProgressBar(
                  value: progress,
                ),
              ),
              imageAssets: Assets.pronunciationBg,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: PronunciationGameBody(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
