import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/home/view/home_page.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class InitialScreenBody extends StatelessWidget {
  const InitialScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      {'name': 'Skydriven', 'avatar': Icons.person},
      {'name': 'Alice', 'avatar': Icons.person_outline},
      {'name': 'Bob', 'avatar': Icons.person_outline},
      {'name': 'Charlie', 'avatar': Icons.person_outline},
      {'name': 'Diana', 'avatar': Icons.person_outline},
      {'name': 'Eve', 'avatar': Icons.person_outline},
    ];
    return BlocBuilder<InitialScreenBloc, InitialScreenState>(
      builder: (context, state) {
        final bloc = context.read<InitialScreenBloc>();
        return CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < students.length) {
                    final s = students[index];
                    return StudentCard(
                      name: s['name'] as String,
                      icon: s['avatar'] as IconData,
                      onPressed: () => context.go(HomePage.route),
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
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SizedBox(
                                    width: 400,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'Student Name',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => context.pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () => bloc.add(
                                                const InitialScreenAddStudentPressed(),
                                              ),
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
                childCount: students.length + 1,
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
