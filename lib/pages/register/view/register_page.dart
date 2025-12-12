import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/initial_screen_page.dart';
import 'package:kidtastic_flutter/widgets/labeled_text_form_field.dart';

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
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 68.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.logo,
                    height: 100,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                  Text(
                    'KIDTASTIC',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  LabeledTextFormField(
                    label: 'Name',
                    isRequired: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  LabeledTextFormField(
                    label: 'Email',
                    isRequired: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  LabeledTextFormField(
                    label: 'Password',
                    isRequired: true,
                    obscure: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
