import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/home/view/home_page.dart';
import 'package:kidtastic_flutter/pages/register/register.dart';
import 'package:kidtastic_flutter/repositories/teacher_repository.dart';

import '../initial_screen.dart';

class InitialScreenPage extends StatelessWidget {
  static const String route = '/initial_screen';
  const InitialScreenPage({super.key});

  void _screenListener(
    BuildContext context,
    InitialScreenState state,
  ) {
    switch (state.screenRequestStatus) {
      case RequestStatus.inProgress:
        break;
      case RequestStatus.success:
        context.go(HomePage.route);
        break;
      default:
        context.go(RegisterPage.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitialScreenBloc(
        initialState: InitialScreenState(),
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      )..add(const InitialScreenCreated()),
      child: BlocListener<InitialScreenBloc, InitialScreenState>(
        listener: _screenListener,
        listenWhen: (previous, current) =>
            previous.screenRequestStatus != current.screenRequestStatus,
        child: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/icon/logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
