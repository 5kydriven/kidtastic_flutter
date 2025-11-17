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

  void _nextQuestionListener(
    BuildContext context,
    CountingGameState state,
  ) async {
    final bloc = context.read<CountingGameBloc>();
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    bloc.add(const CountingGameNextQuestion());
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<CountingGameBloc, CountingGameState>(
            listener: _gameListener,
            listenWhen: (previous, current) =>
                previous.gameSessionRequestStatus !=
                    current.gameSessionRequestStatus &&
                current.gameSessionRequestStatus == RequestStatus.success,
          ),
          BlocListener<CountingGameBloc, CountingGameState>(
            listener: _nextQuestionListener,
            listenWhen: (previous, current) =>
                previous.sessionQuestionRequestStatus !=
                    current.sessionQuestionRequestStatus &&
                current.sessionQuestionRequestStatus == RequestStatus.success,
          ),
        ],
        child: GameScaffold(
          imageAssets: Assets.mathBg,
          appBar: CountingGameAppBar(),
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
        ),
      ),
    );
  }
}
