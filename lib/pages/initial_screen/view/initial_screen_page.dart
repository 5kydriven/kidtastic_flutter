import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/home/view/home_page.dart';
import 'package:kidtastic_flutter/pages/register/view/register_page.dart';
import 'package:kidtastic_flutter/repositories/teacher_repository.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../initial_screen.dart';

class InitialScreenPage extends StatelessWidget {
  static const String route = '/initial_screen';
  const InitialScreenPage({super.key});

  void _screenListener(
    BuildContext context,
    InitialScreenState state,
  ) {
    switch (state.screenRequestStatus) {
      case RequestStatus.failure:
        context.go(RegisterPage.route);
        break;
      default:
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
      child: BlocConsumer<InitialScreenBloc, InitialScreenState>(
        listener: _screenListener,
        listenWhen: (previous, current) =>
            previous.screenRequestStatus != current.screenRequestStatus,
        builder: (context, state) {
          final bloc = context.read<InitialScreenBloc>();
          return GameScaffold(
            imageAssets: Assets.initialScreenBg,
            contentPadding: EdgeInsetsGeometry.all(0),
            bottomBar: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingImageButton(
                  onTap: () {
                    bloc.add(const InitialScreenSfxButtonPressed());
                    context.go(HomePage.route);
                  },
                  child: Image.asset(
                    Assets.initialScreenBtn,
                    fit: BoxFit.fill,
                    width: 300,
                  ),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                Assets.initialScreenLogo,
                fit: BoxFit.fill,
                width: 800,
              ),
            ),
          );
        },
      ),
    );
  }
}
