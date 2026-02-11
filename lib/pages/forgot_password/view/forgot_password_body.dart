import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../widgets/labeled_text_form_field.dart';
import '../bloc/bloc.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  int _previousStep = 1;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _usernameErrorText({
    required BuildContext context,
    required ForgotPasswordState state,
  }) {
    switch (state.username.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      case ErrorType.value:
        return 'Username doesn\'t exist';
      default:
        return null;
    }
  }

  String? _passwordErrorText({
    required BuildContext context,
    required ForgotPasswordState state,
  }) {
    switch (state.password.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _confirmPasswordErrorText({
    required BuildContext context,
    required ForgotPasswordState state,
  }) {
    switch (state.confirmPassword.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      case ErrorType.value:
        return 'Passwords do not match';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        final bloc = context.read<ForgotPasswordBloc>();
        final isPasswordValid =
            state.password.errorType == ErrorType.none &&
            state.confirmPassword.errorType == ErrorType.none &&
            state.password.value.isNotEmpty &&
            state.confirmPassword.value.isNotEmpty;
        final isUsernameValid =
            state.username.errorType == ErrorType.none &&
            state.username.value.isNotEmpty;

        // Only clear controllers when transitioning from step 1 to step 2
        if (state.currentStep == 2 && _previousStep == 1) {
          _passwordController.clear();
          _confirmPasswordController.clear();
        }
        _previousStep = state.currentStep;

        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
          },
          child: Actions(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  if (state.teacherRequestStatus == RequestStatus.inProgress) {
                    return null;
                  }
                  if (state.currentStep == 1) {
                    if (state.username.errorType == ErrorType.none &&
                        state.username.value.isNotEmpty) {
                      bloc.add(const ForgotPasswordNextPressed());
                    }
                  } else {
                    if (state.password.errorType == ErrorType.none &&
                        state.confirmPassword.errorType == ErrorType.none &&
                        state.password.value.isNotEmpty &&
                        state.confirmPassword.value.isNotEmpty) {
                      bloc.add(const ForgotPasswordButtonPressed());
                    }
                  }
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
                      if (state.currentStep == 1) ...[
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Enter your username to verify',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LabeledTextFormField(
                          label: 'Username',
                          isRequired: true,
                          onChanged: (value) => bloc.add(
                            ForgotPasswordUsernameChanged(
                              value: value,
                            ),
                          ),
                          errorMessage: _usernameErrorText(
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
                            onPressed: isUsernameValid
                                ? () => bloc.add(
                                    const ForgotPasswordNextPressed(),
                                  )
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Reset Your Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LabeledTextFormField(
                          key: Key('password_${state.currentStep}'),
                          label: 'New Password',
                          isRequired: true,
                          controller: _passwordController,
                          obscure: state.password.obscureText,
                          onChanged: (value) => bloc.add(
                            ForgotPasswordPasswordChanged(
                              value: value,
                            ),
                          ),
                          errorMessage: _passwordErrorText(
                            context: context,
                            state: state,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => bloc.add(
                              const ForgotPasswordObscurePasswordPressed(),
                            ),
                            icon: Icon(
                              state.password.obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        LabeledTextFormField(
                          key: Key('confirmPassword_${state.currentStep}'),
                          label: 'Confirm Password',
                          isRequired: true,
                          controller: _confirmPasswordController,
                          obscure: state.confirmPassword.obscureText,
                          onChanged: (value) => bloc.add(
                            ForgotPasswordConfirmPasswordChanged(
                              value: value,
                            ),
                          ),
                          errorMessage: _confirmPasswordErrorText(
                            context: context,
                            state: state,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => bloc.add(
                              const ForgotPasswordObscureConfirmPasswordPressed(),
                            ),
                            icon: Icon(
                              state.confirmPassword.obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isPasswordValid
                                ? () => bloc.add(
                                    const ForgotPasswordButtonPressed(),
                                  )
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
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
