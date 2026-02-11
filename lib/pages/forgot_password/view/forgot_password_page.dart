import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/login/view/login_page.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../forgot_password.dart';

class ForgotPasswordPage extends StatelessWidget {
  static const route = '/forgot-password';

  const ForgotPasswordPage({super.key});

  void _forgotPasswordListener(
    BuildContext context,
    ForgotPasswordState state,
  ) {
    switch (state.teacherRequestStatus) {
      case RequestStatus.inProgress:
        Center(
          child: CircularProgressIndicator(),
        );
        break;
      case RequestStatus.success:
        context.go(LoginPage.route);
        break;
      case RequestStatus.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong please try again',
              style: const TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(
              milliseconds: 2500,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(
        initialState: ForgotPasswordState(),
        teacherRepository: RepositoryProvider.of<TeacherRepository>(context),
      )..add(const ForgotPasswordScreenCreated()),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: _forgotPasswordListener,
        listenWhen: (previous, current) =>
            previous.teacherRequestStatus != current.teacherRequestStatus,
        builder: (context, state) {
          final bloc = context.read<ForgotPasswordBloc>();
          return GameScaffold(
            constraintsBox: 550,
            imageAssets: Assets.login,
            header: GameHeaderConfig(
              showBack: true,
              onBack: () {
                context.go(LoginPage.route);
                bloc.add(const ForgotPasswordSfxButtonPressed());
              },
            ),
            child: ForgotPasswordBody(),
          );
        },
      ),
    );
  }
}
