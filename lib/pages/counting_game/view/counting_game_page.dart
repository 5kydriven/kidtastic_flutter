import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/view.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';

class CountingGamePage extends StatelessWidget {
  static const route = '/counting_game';
  final CountingGameState initialState;

  const CountingGamePage({
    super.key,
    required this.initialState,
  });

  void _gameListener(BuildContext context, CountingGameState state) {
    final bloc = context.read<CountingGameBloc>();
    bloc.add(const CountingGameGameEnd());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountingGameBloc(
        initialState: initialState,
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
            current.gameSessionRequestStatus,
        child: SafeArea(
          top: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: CountingGameAppBar(),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    Assets.mathBg,
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: CountingGameBody(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
