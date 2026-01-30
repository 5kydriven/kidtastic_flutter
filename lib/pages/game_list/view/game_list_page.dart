import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';
import 'view.dart';

GlobalKey gameListBodyKey = GlobalKey();
GlobalKey gameListGamesKey = GlobalKey();

class GameListPage extends StatefulWidget {
  static const route = '/game-list';
  final GameListState initialState;

  const GameListPage({
    super.key,
    required this.initialState,
  });

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  final PageController _pageController = PageController();
  TutorialCoachMark? tutorialCoachMark;
  late GameListBloc _bloc;

  void _pageListener(BuildContext context, GameListState state) {
    _pageController.animateToPage(
      state.currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  List<TargetFocus> _targetsForStep(GameListTutorialStep step) {
    final state = _bloc.state;

    switch (step) {
      case GameListTutorialStep.welcome:
        return [
          TargetFocus(
            identify: 'welcome',
            keyTarget: gameListBodyKey,
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
                  return OwlGuideTemplate(
                    message:
                        'Hello ${state.student?.name}, welcome to Kidtastic!',
                  );
                },
              ),
            ],
          ),
        ];

      case GameListTutorialStep.games:
        return [
          TargetFocus(
            identify: 'games',
            keyTarget: gameListGamesKey,
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
                  return OwlGuideTemplate(
                    message: 'This is where you can play games!',
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

  void _tutorialStepListener(BuildContext context, GameListState state) {
    tutorialCoachMark?.finish();
    tutorialCoachMark = null;

    if (state.tutorialStep == GameListTutorialStep.none ||
        state.tutorialStep == GameListTutorialStep.finished) {
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: _targetsForStep(state.tutorialStep),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: true,
      onClickTarget: (_) => _bloc.add(const GameListTutorialNextPressed()),
      onClickOverlay: (_) => _bloc.add(const GameListTutorialNextPressed()),
    );

    tutorialCoachMark?.show(context: context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const GameListTutorialStarted());
    });
  }

  @override
  void dispose() {
    tutorialCoachMark?.finish();
    _pageController.dispose();
    super.dispose();
  }

  GameListBloc _createBloc(BuildContext context) {
    _bloc = GameListBloc(
      initialState: widget.initialState,
      gameRepository: RepositoryProvider.of<GameRepository>(context),
    )..add(const GameListScreenCreated());
    return _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameListBloc>(
      create: _createBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<GameListBloc, GameListState>(
            listener: _pageListener,
            listenWhen: (previous, current) =>
                previous.currentPage != current.currentPage,
          ),
          BlocListener<GameListBloc, GameListState>(
            listener: _tutorialStepListener,
            listenWhen: (previous, current) =>
                previous.tutorialStep != current.tutorialStep,
          ),
        ],
        child: BlocBuilder<GameListBloc, GameListState>(
          builder: (context, state) {
            final bloc = context.read<GameListBloc>();
            return GameScaffold(
              constraintsBox: 800,
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () {
                  context.pop();
                  bloc.add(const GameListSfxButtonPressed());
                },
                onSettings: () {
                  bloc.add(const GameListSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: GameListSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
              ),
              imageAssets: Assets.homeBg,
              child: Card(
                key: gameListBodyKey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: GameListBody(
                  pageController: _pageController,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
