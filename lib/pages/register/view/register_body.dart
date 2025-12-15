import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../widgets/labeled_text_form_field.dart';
import '../bloc/bloc.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  String? _usernameErrorText({
    required BuildContext context,
    required RegisterState state,
  }) {
    switch (state.username.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _nameErrorText({
    required BuildContext context,
    required RegisterState state,
  }) {
    switch (state.name.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _passwordErrorText({
    required BuildContext context,
    required RegisterState state,
  }) {
    switch (state.name.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final bloc = context.read<RegisterBloc>();

        return Card(
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
                  onChanged: (value) => bloc.add(
                    RegisterNameChanged(
                      name: value,
                    ),
                  ),
                  errorMessage: _nameErrorText(
                    context: context,
                    state: state,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                LabeledTextFormField(
                  label: 'Username',
                  isRequired: true,
                  onChanged: (value) => bloc.add(
                    RegisterPasswordChanged(
                      password: value,
                    ),
                  ),
                  errorMessage: _usernameErrorText(
                    context: context,
                    state: state,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                LabeledTextFormField(
                  label: 'Password',
                  isRequired: true,
                  obscure: true,
                  onChanged: (value) => bloc.add(
                    RegisterPasswordChanged(
                      password: value,
                    ),
                  ),
                  errorMessage: _passwordErrorText(
                    context: context,
                    state: state,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => bloc.add(const RegisterButtonPressed()),
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
        );
      },
    );
  }
}
