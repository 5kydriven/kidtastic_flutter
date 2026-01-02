import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  if (state.loginRequestStatus == RequestStatus.inProgress) {
                    return null;
                  }
                  bloc.add(const LoginButtonPressed());
                  return null;
                },
              ),
            },
            child: Focus(
              autofocus: true,
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
                      const Text(
                        'KIDTASTIC',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Visibility(
                        visible:
                            state.loginRequestStatus == RequestStatus.failure,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 24,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(
                              alpha: 0.1,
                            ),
                            border: Border.all(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Incorrect username or password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                      const SizedBox(
                        height: 12,
                      ),
                      LabeledTextFormField(
                        label: 'Password',
                        isRequired: true,
                        obscure: !state.password.obscureText,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              bloc.add(LoginObscurePasswordPressed()),
                          icon: Icon(
                            !state.password.obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
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
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => bloc.add(const LoginButtonPressed()),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
