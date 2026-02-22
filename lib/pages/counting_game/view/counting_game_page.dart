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
                  bloc.add(const CountingGameSfxButtonPressed());
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
                  bloc.add(const CountingGameSfxButtonPressed());
                  bloc.add(const CountingGameScreenCreated());
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
                builder: (_, _) {
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
                builder: (_, _) {
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
                builder: (_, _) {
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
                builder: (_, _) {
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
      skipWidget: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 36,
        ),
        child: FilledButton(
          onPressed: () {
            _bloc.add(const CountingGameSfxButtonPressed());
            tutorialCoachMark?.skip();
          },
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: false,
      onClickTarget: (_) => _bloc.add(const CountingGameTutorialNextPressed()),
      onClickOverlay: (_) => _bloc.add(const CountingGameTutorialNextPressed()),
      onSkip: () => true,
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
                key: countingWelcomeKey,
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
