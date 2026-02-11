import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';
import 'view.dart';

GlobalKey pronunciationWelcomeKey = GlobalKey();
GlobalKey pronunciationContentsKey = GlobalKey();
GlobalKey pronunciationButtonsKey = GlobalKey();

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
  TutorialCoachMark? tutorialCoachMark;
  late PronunciationGameBloc _bloc;

  void _gameListener(BuildContext context, PronunciationGameState state) {
    final bloc = context.read<PronunciationGameBloc>();
    if (!state.isGameEnded) return;
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
                  'Great job. You did great!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
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
                bloc.add(const PronunciationGameSfxButtonPressed());
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
                bloc.add(const PronunciationGameSfxButtonPressed());
                bloc.add(const PronunciationGameScreenCreated());
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

  List<TargetFocus> _targetsForStep(PronunciationGameTutorialStep step) {
    switch (step) {
      case PronunciationGameTutorialStep.welcome:
        return [
          TargetFocus(
            identify: 'pronunciationWelcome',
            keyTarget: pronunciationWelcomeKey,
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
                        'Hoot! Welcome to the Speaking Game! Let’s learn how to say new words together!',
                  );
                },
              ),
            ],
          ),
        ];

      case PronunciationGameTutorialStep.contents:
        return [
          TargetFocus(
            identify: 'pronunciationContents',
            keyTarget: pronunciationContentsKey,
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
                  return const OwlGuideTemplate(
                    message:
                        'Look at the picture! Can you say the word out loud?',
                  );
                },
              ),
            ],
          ),
        ];

      case PronunciationGameTutorialStep.buttons:
        return [
          TargetFocus(
            identify: 'pronunciationButtons',
            keyTarget: pronunciationButtonsKey,
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
                        'Tap the speaker to hear the word, then tap the mic to say it yourself!',
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
    PronunciationGameState state,
  ) {
    tutorialCoachMark?.finish();
    tutorialCoachMark = null;

    if (state.tutorialStep == PronunciationGameTutorialStep.none ||
        state.tutorialStep == PronunciationGameTutorialStep.finished) {
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: _targetsForStep(state.tutorialStep),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: true,
      onClickTarget: (_) =>
          _bloc.add(const PronunciationGameTutorialNextPressed()),
      onClickOverlay: (_) =>
          _bloc.add(const PronunciationGameTutorialNextPressed()),
    );

    tutorialCoachMark?.show(context: context);
  }

  void _modelListner(BuildContext context, PronunciationGameState state) {
    _bloc.add(const PronunciationGameTutorialStarted());
  }

  @override
  void initState() {
    _confettiController = ConfettiController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_bloc.state.isModelReady) {
        _bloc.add(const PronunciationGameTutorialStarted());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tutorialCoachMark?.finish();
    _confettiController.kill();
    super.dispose();
  }

  PronunciationGameBloc _createBloc(BuildContext context) {
    _bloc = PronunciationGameBloc(
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
      studentInsightRepository: RepositoryProvider.of<StudentInsightRepository>(
        context,
      ),
    )..add(const PronunciationGameScreenCreated());
    return _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PronunciationGameBloc>(
      create: _createBloc,
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
          BlocListener<PronunciationGameBloc, PronunciationGameState>(
            listener: _tutorialStepListener,
            listenWhen: (previous, current) =>
                previous.tutorialStep != current.tutorialStep,
          ),
          BlocListener<PronunciationGameBloc, PronunciationGameState>(
            listener: _modelListner,
            listenWhen: (previous, current) =>
                previous.isModelReady != current.isModelReady,
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
              key: pronunciationWelcomeKey,
              constraintsBox: 800,
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
