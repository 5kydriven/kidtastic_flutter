import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/initial_screen/bloc/bloc.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/view.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

class InitialScreenPage extends StatelessWidget {
  static const route = '/initial_screen';

  const InitialScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitialScreenBloc(
        initialState: InitialScreenState(),
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
      )..add(const InitialScreenScreenCreated()),
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 16,
            ),
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {},
                  child: Text('Teacher'),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const InitialScreenHeader(),

              Container(
                width: 800,
                height: 500,

                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: InitialScreenBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
