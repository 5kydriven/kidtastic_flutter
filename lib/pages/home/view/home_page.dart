import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import 'view.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  const HomePage({super.key});

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
        initialState: HomeState(),
      ),
      child: BlocListener<HomeBloc, HomeState>(
        listener: _pageListener,
        listenWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
        child: Scaffold(
          appBar: const HomeAppBar(),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hello John Doe',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Let's play and learn",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    HomeGames(
                      pageController: _pageController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
