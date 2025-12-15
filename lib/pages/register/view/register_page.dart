import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/initial_screen_page.dart';
import 'package:kidtastic_flutter/pages/register/view/register_body.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class RegisterPage extends StatelessWidget {
  static const route = '/register';

  const RegisterPage({super.key});

  void _teacherListener(BuildContext context, RegisterState state) {
    switch (state.screenRequestStatus) {
      case RequestStatus.success:
        context.push(InitialScreenPage.route);
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
      ),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: _teacherListener,
        listenWhen: (previous, current) =>
            previous.screenRequestStatus != current.screenRequestStatus,
        child: GameScaffold(
          constraintsBox: 550,
          imageAssets: Assets.login,
          child: RegisterBody(),
        ),
      ),
    );
  }
}
