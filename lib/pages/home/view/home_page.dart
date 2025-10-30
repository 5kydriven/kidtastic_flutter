import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';
import 'view.dart';

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

  void _pageListener(BuildContext context, HomeState state) {
    _pageController.animateToPage(
      state.currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        initialState: widget.initialState,
        gameRepository: RepositoryProvider.of<GameRepository>(context),
      )..add(const HomeScreenCreated()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: _pageListener,
        listenWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return GameScaffold(
              appBar: HomeAppBar(),
              imageAssets: Assets.homeBg,
              child: Card(
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
