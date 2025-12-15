import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/pages/login/view/view.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';

  const LoginPage({super.key});

  void _loginListener(BuildContext context, LoginState state) {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        initialState: LoginState(),
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: _loginListener,
        listenWhen: (previous, current) =>
            previous.loginRequestStatus != current.loginRequestStatus,
        child: GameScaffold(
          constraintsBox: 550,
          imageAssets: Assets.login,
          child: LoginBody(),
        ),
      ),
    );
  }
}
