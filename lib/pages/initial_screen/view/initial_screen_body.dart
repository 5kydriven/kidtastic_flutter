import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/home/view/home_page.dart';

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
                      onTap: () => debugPrint('Add student clicked'),
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
            maxCrossAxisExtent: 160, // 🔹 each card width
            mainAxisExtent: 200, // 🔹 each card height
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
        ),
      ],
    );
  }
}
