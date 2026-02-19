import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:tracing_game/tracing_game.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../tracing_game.dart';

class TracingGamePage extends StatelessWidget {
  static const route = '/tracing-game';
  final TracingGameState initialState;

  const TracingGamePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracingGameBloc(
        initialState: initialState,
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
      ),
      child: GameScaffold(
        imageAssets: Assets.adminBg,
        constraintsBox: 800,
        header: GameHeaderConfig(
          showBack: true,
          onBack: () => context.pop(),
          showSettings: true,
        ),
        child: TracingCharsGame(
          showAnchor: true,
          onCurrentTracingScreenFinished: (index) async {
            print('/////onCurrentTracingScreenFinished:$index');
          },
          onGameFinished: (int screenIndex) async {
            print('/////onGameFinished:$screenIndex');
          },
          onTracingUpdated: (int currentTracingIndex) async {
            print('/////onTracingUpdated:$currentTracingIndex');
          },
          traceShapeModel: [
            TraceCharsModel(
              chars: [
                TraceCharModel(
                  char: 'F',
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.orange,
                  ),
                ),
                TraceCharModel(
                  char: 'f',
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.orange,
                  ),
                ),
              ],
            ),
            TraceCharsModel(
              chars: [
                TraceCharModel(
                  char: 'A',
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.orange,
                  ),
                ),
                TraceCharModel(
                  char: 'a',
                  traceShapeOptions: const TraceShapeOptions(
                    innerPaintColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
