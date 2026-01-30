import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/home/bloc/bloc.dart';
import 'package:kidtastic_flutter/pages/login/view/login_page.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import 'view.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  void _pageListener(
    BuildContext context,
    HomeState state,
  ) {
    _pageController.animateToPage(
      state.currentPage,
      duration: const Duration(
        milliseconds: 350,
      ),
      curve: Curves.easeInOut,
    );
  }

  void _addStudentDialogListner(
    BuildContext context,
    HomeState state,
  ) {
    switch (state.studentRequestStatus) {
      case RequestStatus.success:
        if (Navigator.canPop(context)) {
          context.pop();
        }
      default:
    }
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
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
      )..add(const HomeScreenCreated()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: _pageListener,
            listenWhen: (previous, current) =>
                previous.currentPage != current.currentPage,
          ),
          BlocListener<HomeBloc, HomeState>(
            listener: _addStudentDialogListner,
            listenWhen: (previous, current) =>
                previous.studentRequestStatus != current.studentRequestStatus,
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeBloc>();
            return GameScaffold(
              constraintsBox: 800,
              imageAssets: Assets.homeBg,
              header: GameHeaderConfig(
                showSettings: true,
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
              bottomBar: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xffFFC30E),
                  ),
                  onPressed: () {
                    bloc.add(const HomeSfxButtonPressed());
                    context.push(LoginPage.route);
                  },
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
                  child: HomeBody(
                    pageController: _pageController,
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
