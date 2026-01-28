import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/counting_game/view/view.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';

GlobalKey countingWelcomeKey = GlobalKey();
GlobalKey countingQuestionKey = GlobalKey();
GlobalKey countingContentsKey = GlobalKey();
GlobalKey countingButtonsKey = GlobalKey();

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
  TutorialCoachMark? tutorialCoachMark;
  late CountingGameBloc _bloc;

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
                  bloc.add(const CountingGameSfxButtonPressed());
                  context.pop();
                  context.pop();
                },
                child: const Text('Choose another game'),
              ),
              TextButton(
                onPressed: () {
                  bloc.add(const CountingGameSfxButtonPressed());
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
    bloc.add(const CountingGameSfxButtonPressed());
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
                bloc.add(const CountingGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const CountingGameSfxButtonPressed());
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

  List<TargetFocus> _targetsForStep(CountingGameTutorialStep step) {
    final state = _bloc.state;

    switch (step) {
      case CountingGameTutorialStep.welcome:
        return [
          TargetFocus(
            identify: 'countingWelcome',
            keyTarget: countingWelcomeKey,
            shape: ShapeLightFocus.RRect,
            radius: 18,
            enableOverlayTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.custom,
                customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                builder: (_, __) {
                  return const OwlGuideTemplate(
                    message:
                        'Hoot! Welcome to the Counting Game! Let’s go on a number adventure and see how many things we can find together!',
                  );
                },
              ),
            ],
          ),
        ];

      case CountingGameTutorialStep.question:
        return [
          TargetFocus(
            identify: 'countingQuestion',
            keyTarget: countingQuestionKey,
            shape: ShapeLightFocus.RRect,
            radius: 18,
            enableOverlayTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.custom,
                customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                builder: (_, __) {
                  return const OwlGuideTemplate(
                    message: 'First, let’s use our eyes to read the question!',
                  );
                },
              ),
            ],
          ),
        ];

      case CountingGameTutorialStep.contents:
        return [
          TargetFocus(
            identify: 'countingContents',
            keyTarget: countingContentsKey,
            shape: ShapeLightFocus.RRect,
            radius: 18,
            enableOverlayTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.custom,
                customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height * 0.5,
                  left: MediaQuery.of(context).size.width * -0.05,
                ),
                builder: (_, __) {
                  final question = state.question[state.currentIndex].question;

                  final item = question
                      ?.replaceAll(
                        RegExp(r'How many ', caseSensitive: false),
                        '',
                      )
                      .replaceAll(
                        RegExp(r' are there\?', caseSensitive: false),
                        '',
                      )
                      .trim();
                  return OwlGuideTemplate(
                    message: 'Now, count them up! How many $item do you see?',
                  );
                },
              ),
            ],
          ),
        ];

      case CountingGameTutorialStep.buttons:
        return [
          TargetFocus(
            identify: 'countingButtons',
            keyTarget: countingButtonsKey,
            shape: ShapeLightFocus.RRect,
            radius: 18,
            enableOverlayTab: true,
            contents: [
              TargetContent(
                align: ContentAlign.custom,
                customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                builder: (_, __) {
                  return const OwlGuideTemplate(
                    message:
                        'Pick the button with the right number on it! You’re going to be a counting superstar. Good luck!',
                  );
                },
              ),
            ],
          ),
        ];

      default:
        return [];
    }
  }

  void _tutorialStepListener(BuildContext context, CountingGameState state) {
    tutorialCoachMark?.finish();
    tutorialCoachMark = null;

    if (state.tutorialStep == CountingGameTutorialStep.none ||
        state.tutorialStep == CountingGameTutorialStep.finished) {
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: _targetsForStep(state.tutorialStep),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: true,
      onClickTarget: (_) => _bloc.add(const CountingGameTutorialNextPressed()),
      onClickOverlay: (_) => _bloc.add(const CountingGameTutorialNextPressed()),
    );

    tutorialCoachMark?.show(context: context);
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const CountingGameTutorialStarted());
    });
  }

  @override
  void dispose() {
    tutorialCoachMark?.finish();
    _confettiController.kill();
    super.dispose();
  }

  CountingGameBloc _createBloc(BuildContext context) {
    _bloc = CountingGameBloc(
      initialState: widget.initialState,
      gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
        context,
      ),
      gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
        context,
      ),
      sessionQuestionRepository:
          RepositoryProvider.of<SessionQuestionRepository>(context),
      studentInsightRepository: RepositoryProvider.of<StudentInsightRepository>(
        context,
      ),
    )..add(const CountingGameScreenCreated());
    return _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CountingGameBloc>(
      create: _createBloc,
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
            listener: _tutorialStepListener,
            listenWhen: (previous, current) =>
                previous.tutorialStep != current.tutorialStep,
          ),
        ],
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
              key: countingWelcomeKey,
              constraintsBox: 800,
              imageAssets: Assets.mathBg,
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () => _confirmExit(context, bloc),
                onSettings: () {
                  bloc.add(const CountingGameSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: CountingGameSettingsDialog(
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
