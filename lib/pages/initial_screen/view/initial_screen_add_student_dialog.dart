import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';

class InitialScreenAddStudentDialog extends StatelessWidget {
  final InitialScreenBloc initialScreenBloc;

  const InitialScreenAddStudentDialog({
    super.key,
    required this.initialScreenBloc,
  });

  String? _nameErrorText({
    required BuildContext context,
    required InitialScreenState state,
  }) {
    switch (state.name?.errorType) {
      case ErrorType.empty:
        return 'Field cannot be empty';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InitialScreenBloc>.value(
      value: initialScreenBloc,
      child: BlocBuilder<InitialScreenBloc, InitialScreenState>(
        builder: (context, state) {
          final bloc = context.read<InitialScreenBloc>();

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 400,
              height: 500,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  const Text(
                    'Add Student',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Create your profile to start learning and playing',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24,
                    children: [
                      IconButton.outlined(
                        iconSize: 76,
                        icon: Icon(Icons.person),
                        onPressed: () {},
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('Change Avatar'),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        onChanged: (value) => bloc.add(
                          InitialScreenNameChanged(
                            value: value,
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorText: _nameErrorText(
                            context: context,
                            state: state,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 44,
                    padding: EdgeInsets.symmetric(
                      horizontal: 44,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        bloc.add(
                          const InitialScreenAddStudentPressed(),
                        );
                        context.pop();
                      },
                      child: const Text('Let\'s Go!'),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
