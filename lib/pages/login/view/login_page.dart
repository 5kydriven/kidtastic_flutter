import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/pages/dashboard/view/dashboard_page.dart';
import 'package:kidtastic_flutter/pages/login/view/view.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';

  const LoginPage({super.key});

  void _loginListener(BuildContext context, LoginState state) {
    switch (state.loginRequestStatus) {
      case RequestStatus.success:
        context.push(DashboardPage.route);
        break;
      case RequestStatus.failure:
      default:
        break;
    }
  }

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
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final bloc = context.read<LoginBloc>();
            return GameScaffold(
              constraintsBox: 550,
              imageAssets: Assets.login,
              header: GameHeaderConfig(
                showBack: true,
                onBack: () {
                  context.pop();
                  bloc.add(const LoginSfxButtonPressed());
                },
              ),
              child: LoginBody(),
            );
          },
        ),
      ),
    );
  }
}
