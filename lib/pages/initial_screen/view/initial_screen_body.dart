import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/home/home.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/view.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class InitialScreenBody extends StatelessWidget {
  const InitialScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitialScreenBloc, InitialScreenState>(
      builder: (context, state) {
        final bloc = context.read<InitialScreenBloc>();
        return CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < state.students.length) {
                    final student = state.students[index];
                    return StudentCard(
                      name: student.name ?? '',
                      icon: Icons.person_outline,
                      onTap: () => context.push(
                        HomePage.route,
                        extra: HomeState(
                          student: student,
                        ),
                      ),
                      onPressed: () => bloc.add(
                        InitialScreenDeleteStudentPressed(
                          id: student.id ?? 0,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: 130,
                      height: 170,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => InitialScreenAddStudentDialog(
                              initialScreenBloc: bloc,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  'Add Student',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                childCount: state.students.length + 1,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                mainAxisExtent: 200,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
