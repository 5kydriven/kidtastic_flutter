import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/shape_game/shape_game.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

class ShapeGamePage extends StatelessWidget {
  static const String route = '/shape-game';
  final ShapeGameState initialState;

  const ShapeGamePage({
    super.key,
    required this.initialState,
  });

  void _gameListener(BuildContext context, ShapeGameState state) {
    final bloc = context.read<ShapeGameBloc>();
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
                  bloc.add(const ShapeGameScreenCreated());
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShapeGameBloc(
        initialState: initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(context),
      )..add(const ShapeGameScreenCreated()),
      child: BlocListener<ShapeGameBloc, ShapeGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
        child: GameScaffold(
          appBar: ShapeGameAppBar(),
          imageAssets: Assets.matchTheShape,
          child: ShapeGameBody(),
        ),
      ),
    );
  }
}
