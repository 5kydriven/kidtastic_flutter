import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/initial_screen/bloc/bloc.dart';
import 'package:kidtastic_flutter/pages/login/view/login_page.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import 'view.dart';

class InitialScreenPage extends StatefulWidget {
  static const route = '/initial_screen';

  const InitialScreenPage({super.key});

  @override
  State<InitialScreenPage> createState() => _InitialScreenPageState();
}

class _InitialScreenPageState extends State<InitialScreenPage> {
  final PageController _pageController = PageController();

  void _pageListener(
    BuildContext context,
    InitialScreenState state,
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
    InitialScreenState state,
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
      create: (context) => InitialScreenBloc(
        initialState: InitialScreenState(),
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
      )..add(const InitialScreenScreenCreated()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<InitialScreenBloc, InitialScreenState>(
            listener: _pageListener,
            listenWhen: (previous, current) =>
                previous.currentPage != current.currentPage,
          ),
          BlocListener<InitialScreenBloc, InitialScreenState>(
            listener: _addStudentDialogListner,
            listenWhen: (previous, current) =>
                previous.studentRequestStatus != current.studentRequestStatus,
          ),
        ],
        child: BlocBuilder<InitialScreenBloc, InitialScreenState>(
          builder: (context, state) {
            final bloc = context.read<InitialScreenBloc>();
            return GameScaffold(
              imageAssets: Assets.homeBg,
              header: GameHeaderConfig(
                showSettings: true,
                onSettings: () {
                  bloc.add(const InitialScreenSfxButtonPressed());
                  showDialog(
                    context: context,
                    builder: (_) => SizedBox(
                      child: InitialScreenSettingsDialog(
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
                    bloc.add(const InitialScreenSfxButtonPressed());
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
                  child: InitialScreenBody(
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
