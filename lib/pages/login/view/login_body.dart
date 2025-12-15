import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/widgets/labeled_text_form_field.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../bloc/bloc.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  String? _passwordErrorText({
    required BuildContext context,
    required LoginState state,
  }) {
    switch (state.password.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _usernameErrorText({
    required BuildContext context,
    required LoginState state,
  }) {
    switch (state.username.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Image.asset(
                Assets.logo,
                height: 200,
                width: 200,
              ),
              Text(
                'KIDTASTIC',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              LabeledTextFormField(
                label: 'Username',
                isRequired: true,
                onChanged: (value) => bloc.add(
                  LoginUsernameChanged(
                    username: value,
                  ),
                ),
                errorMessage: _usernameErrorText(
                  context: context,
                  state: state,
                ),
              ),
              LabeledTextFormField(
                label: 'Password',
                isRequired: true,
                obscure: true,
                onChanged: (value) => bloc.add(
                  LoginPasswordChanged(
                    password: value,
                  ),
                ),
                errorMessage: _passwordErrorText(
                  context: context,
                  state: state,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => bloc.add(const LoginButtonPressed()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
