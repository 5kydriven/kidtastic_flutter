import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';
import 'view.dart';

GlobalKey homeBodyKey = GlobalKey();
GlobalKey homeGamesKey = GlobalKey();

class HomePage extends StatefulWidget {
  static const route = '/home';
  final HomeState initialState;

  const HomePage({
    super.key,
    required this.initialState,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  TutorialCoachMark? tutorialCoachMark;
  late HomeBloc _bloc;

  void _pageListener(BuildContext context, HomeState state) {
    _pageController.animateToPage(
      state.currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  List<TargetFocus> _targetsForStep(HomeTutorialStep step) {
    final state = _bloc.state;

    switch (step) {
      case HomeTutorialStep.welcome:
        return [
          TargetFocus(
            identify: 'welcome',
            keyTarget: homeBodyKey,
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

      case HomeTutorialStep.games:
        return [
          TargetFocus(
            identify: 'games',
            keyTarget: homeGamesKey,
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

  void _tutorialStepListener(BuildContext context, HomeState state) {
    tutorialCoachMark?.finish();
    tutorialCoachMark = null;

    if (state.tutorialStep == HomeTutorialStep.none ||
        state.tutorialStep == HomeTutorialStep.finished) {
      return;
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: _targetsForStep(state.tutorialStep),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      hideSkip: true,
      onClickTarget: (_) => _bloc.add(const HomeTutorialNextPressed()),
      onClickOverlay: (_) => _bloc.add(const HomeTutorialNextPressed()),
    );

    tutorialCoachMark?.show(context: context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const HomeTutorialStarted());
    });
  }

  @override
  void dispose() {
    tutorialCoachMark?.finish();
    _pageController.dispose();
    super.dispose();
  }

  HomeBloc _createBloc(BuildContext context) {
    _bloc = HomeBloc(
      initialState: widget.initialState,
      gameRepository: RepositoryProvider.of<GameRepository>(context),
    )..add(const HomeScreenCreated());
    return _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: _createBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: _pageListener,
            listenWhen: (previous, current) =>
                previous.currentPage != current.currentPage,
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: _tutorialStepListener,
            listenWhen: (previous, current) =>
                previous.tutorialStep != current.tutorialStep,
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return GameScaffold(
              constraintsBox: 800,
              header: GameHeaderConfig(
                showBack: true,
                showSettings: true,
                onBack: () {
                  context.pop();
                  bloc.add(const HomeSfxButtonPressed());
                },
                onSettings: () {
                  bloc.add(const HomeSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: HomeSettingsDialog(
                        context: context,
                      ),
                    ),
                  );
                },
              ),
              imageAssets: Assets.homeBg,
              child: Card(
                key: homeBodyKey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: HomeBody(
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
