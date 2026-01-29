import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../bloc/bloc.dart';
import 'view.dart';

GlobalKey matchWelcomeKey = GlobalKey();
GlobalKey matchQuestionKey = GlobalKey();
GlobalKey matchContentsKey = GlobalKey();
GlobalKey matchButtonsKey = GlobalKey();

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
  TutorialCoachMark? tutorialCoachMark;
  late MatchGameBloc _bloc;

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

  void _confirmExit(BuildContext context, MatchGameBloc bloc) {
    final state = bloc.state;
    bloc.add(const MatchGameSfxButtonPressed());
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
                bloc.add(const MatchGameSfxButtonPressed());
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(const MatchGameSfxButtonPressed());
                if (state.currentIndex != 0) {
                  bloc.add(const MatchGameGameEnd());
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

  List<TargetFocus> _targetsForStep(MatchGameTutorialStep step) {
    final state = _bloc.state;

    switch (step) {
      case MatchGameTutorialStep.welcome:
        return [
          TargetFocus(
            identify: 'matchWelcome',
            keyTarget: matchWelcomeKey,
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
                        'Hoot! Welcome to the Match Game! Let’s go on a number adventure and see how many things we can find together!',
                  );
                },
              ),
            ],
          ),
        ];

      case MatchGameTutorialStep.question:
        return [
          TargetFocus(
            identify: 'matchQuestion',
            keyTarget: matchQuestionKey,
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

      case MatchGameTutorialStep.contents:
        return [
          TargetFocus(
            identify: 'matchContents',
            keyTarget: matchContentsKey,
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

      case MatchGameTutorialStep.buttons:
        return [
          TargetFocus(
            identify: 'matchButtons',
            keyTarget: matchButtonsKey,
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
                        'Pick the button with the right number on it! You’re going to be a match superstar. Good luck!',
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

  void _tutorialStepListener(
    BuildContext context,
    MatchGameState state,
  ) {
    tutorialCoachMark?.finish();
    tutorialCoachMark = null;

    if (state.tutorialStep == MatchGameTutorialStep.none ||
        state.tutorialStep == MatchGameTutorialStep.finished) {
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: _targetsForStep(state.tutorialStep),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: true,
      onClickTarget: (_) => _bloc.add(const MatchGameTutorialNextPressed()),
      onClickOverlay: (_) => _bloc.add(const MatchGameTutorialNextPressed()),
    );

    tutorialCoachMark?.show(context: context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const MatchGameTutorialStarted());
    });
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
    tutorialCoachMark?.finish();
    _animationController.dispose();
    _confettiController.kill();
    super.dispose();
  }

  MatchGameBloc _createBloc(BuildContext context) {
    _bloc = MatchGameBloc(
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
    )..add(const MatchGameScreenCreated());
    return _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MatchGameBloc>(
      create: _createBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MatchGameBloc, MatchGameState>(
            listener: _gameListener,
            listenWhen: (previous, current) =>
                previous.gameSessionRequestStatus !=
                    current.gameSessionRequestStatus &&
                current.gameSessionRequestStatus == RequestStatus.success,
          ),
          BlocListener<MatchGameBloc, MatchGameState>(
            listener: _tutorialStepListener,
            listenWhen: (previous, current) =>
                previous.tutorialStep != current.tutorialStep,
          ),
        ],
        child: BlocBuilder<MatchGameBloc, MatchGameState>(
          builder: (context, state) {
            final bloc = context.read<MatchGameBloc>();
            final progress = state.question.isNotEmpty
                ? ((state.currentIndex + 1) / state.question.length).clamp(
                    0.0,
                    1.0,
                  )
                : 0.0;
            return GameScaffold(
              constraintsBox: 800,
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () => _confirmExit(context, bloc),
                onSettings: () {
                  bloc.add(const MatchGameSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: MatchGameSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
                center: GameProgressBar(
                  value: progress,
                ),
              ),
              imageAssets: Assets.matchTheShape,
              child: MatchGameBody(
                confettiController: _confettiController,
                animationController: _animationController,
                shake: _shake,
              ),
            );
          },
        ),
      ),
    );
  }
}
