import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/initial_screen/bloc/bloc.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/initial_screen_body.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/widgets/game_scaffold.dart';

import '../../../constants/constants.dart';

class InitialScreenPage extends StatefulWidget {
  static const route = '/initial_screen';

  const InitialScreenPage({super.key});

  @override
  State<InitialScreenPage> createState() => _InitialScreenPageState();
}

class _InitialScreenPageState extends State<InitialScreenPage> {
  final PageController _pageController = PageController();

  void _pageListener(BuildContext context, InitialScreenState state) {
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
      create: (context) => InitialScreenBloc(
        initialState: InitialScreenState(),
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
      )..add(const InitialScreenScreenCreated()),
      child: BlocListener<InitialScreenBloc, InitialScreenState>(
        listener: _pageListener,
        listenWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
        child: GameScaffold(
          constraintsBox: 800,
          imageAssets: Assets.homeBg,
          bottomBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 16,
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xffFFC30E),
              ),
              onPressed: () {},
              child: Text('Teacher'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: InitialScreenBody(
                pageController: _pageController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
