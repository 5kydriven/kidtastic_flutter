import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../bloc/bloc.dart';
import 'view.dart';

class MatchGamePage extends StatefulWidget {
  static const String route = '/match-game';
  final MatchGameState initialState;

  const MatchGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<MatchGamePage> createState() => _MatchGamePageState();
}

class _MatchGamePageState extends State<MatchGamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  late Animation<double> _shake;

  void _gameListener(BuildContext context, MatchGameState state) {
    final bloc = context.read<MatchGameBloc>();
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
                  bloc.add(const MatchGameScreenCreated());
                  context.pop();
                },
                child: const Text('Play again'),
              ),
            ],
          );
        },
      );
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );
    _shake =
        Tween<double>(
              begin: 0,
              end: 40,
            )
            .chain(
              CurveTween(
                curve: Curves.elasticInOut,
              ),
            )
            .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchGameBloc(
        initialState: widget.initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(context),
      )..add(const MatchGameScreenCreated()),
      child: BlocListener<MatchGameBloc, MatchGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
        child: GameScaffold(
          appBar: MatchGameAppBar(),
          imageAssets: Assets.matchTheShape,
          child: MatchGameBody(
            confettiController: _confettiController,
            animationController: _animationController,
            shake: _shake,
          ),
        ),
      ),
    );
  }
}
