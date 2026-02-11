import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class StudentEditBody extends StatelessWidget {
  final LayerLink layerLink;
  final VoidCallback toggleAvatarMenu;

  const StudentEditBody({
    super.key,
    required this.layerLink,
    required this.toggleAvatarMenu,
  });

  String? _firstNameErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.firstName.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _lastNameErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.lastName.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  String? _genderErrorText({
    required BuildContext context,
    required StudentEditState state,
  }) {
    switch (state.gender.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentEditBloc, StudentEditState>(
      builder: (context, state) {
        final bloc = context.read<StudentEditBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Edit Student',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CompositedTransformTarget(
                      link: layerLink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  state.selectedAvatar,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          FilledButton(
                            onPressed: toggleAvatarMenu,
                            child: const Text('Choose Avatar'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabeledTextFormField(
                      label: 'First Name',
                      initialValue: state.firstName.value,
                      isRequired: true,
                      onChanged: (value) => bloc.add(
                        StudentEditFirstNameChanged(
                          value: value,
                        ),
                      ),
                      errorMessage: _firstNameErrorText(
                        context: context,
                        state: state,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LabeledTextFormField(
                      label: 'Last Name',
                      initialValue: state.lastName.value,
                      isRequired: true,
                      onChanged: (value) => bloc.add(
                        StudentEditLastNameChanged(value: value),
                      ),
                      errorMessage: _lastNameErrorText(
                        context: context,
                        state: state,
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField(
                      initialValue: state.gender.value.isNotEmpty
                          ? state.gender.value
                          : null,
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) => bloc.add(
                        StudentEditGenderChanged(
                          value: value ?? '',
                        ),
                      ),
                      decoration: InputDecoration(
                        errorText: _genderErrorText(
                          context: context,
                          state: state,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 300,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => bloc.add(
                  const StudentEditSavePressed(),
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                bloc.add(const StudentEditErrorTypeCleared());
                bloc.add(const StudentEditSfxButtonPressed());
                context.pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
