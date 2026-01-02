import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    switch (state.password.errorType) {
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

        if (state.screenRequestStatus == RequestStatus.failure) {
          return Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
            },
            child: Actions(
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    if (state.registerRequestStatus ==
                        RequestStatus.inProgress) {
                      return null;
                    }
                    bloc.add(const RegisterButtonPressed());
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
                            RegisterUsernameChanged(
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
                          onChanged: (value) => bloc.add(
                            RegisterPasswordChanged(
                              password: value,
                            ),
                          ),
                          errorMessage: _passwordErrorText(
                            context: context,
                            state: state,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                bloc.add(RegisterObscurePasswordPressed()),
                            icon: Icon(
                              !state.password.obscureText
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
                            onPressed: () =>
                                bloc.add(const RegisterButtonPressed()),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Register',
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
        }

        return const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: Color(0xffA66609),
              strokeWidth: 8,
            ),
          ),
        );
      },
    );
  }
}
