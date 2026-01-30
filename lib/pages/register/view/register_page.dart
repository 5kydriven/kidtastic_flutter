import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/pages/home/home.dart';
import 'package:kidtastic_flutter/pages/register/view/register_body.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class RegisterPage extends StatelessWidget {
  static const route = '/register';

  const RegisterPage({super.key});

  void _screenListener(
    BuildContext context,
    RegisterState state,
  ) {
    switch (state.screenRequestStatus) {
      case RequestStatus.success:
        context.push(HomePage.route);
        break;
      case RequestStatus.failure:
      default:
        break;
    }
  }

  void _registerListener(
    BuildContext context,
    RegisterState state,
  ) {
    switch (state.registerRequestStatus) {
      case RequestStatus.success:
        context.push(HomePage.route);
        break;
      case RequestStatus.failure:
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        initialState: RegisterState(),
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      )..add(const RegisterScreenCreated()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: _screenListener,
            listenWhen: (previous, current) =>
                previous.screenRequestStatus != current.screenRequestStatus,
          ),
          BlocListener<RegisterBloc, RegisterState>(
            listener: _registerListener,
            listenWhen: (previous, current) =>
                previous.registerRequestStatus != current.registerRequestStatus,
          ),
        ],
        child: GameScaffold(
          constraintsBox: 550,
          imageAssets: Assets.login,
          child: RegisterBody(),
        ),
      ),
    );
  }
}
