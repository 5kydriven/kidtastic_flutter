import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/initial_screen/widgets/student_card.dart';
import 'package:responsive_framework/responsive_framework.dart';

class InitialScreenPage extends StatelessWidget {
  static const route = '/initial_screen';

  const InitialScreenPage({super.key});

  int _getCrossAxisCount(ResponsiveBreakpointsData bp) {
    if (bp.smallerThan(TABLET)) {
      return 2;
    } else if (bp.isTablet) {
      return 3;
    } else {
      return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bp = ResponsiveBreakpoints.of(context);

    final students = [
      {'name': 'Skydriven', 'avatar': Icons.person},
      {'name': 'Alice', 'avatar': Icons.person_outline},
      {'name': 'Bob', 'avatar': Icons.person_outline},
      {'name': 'Charlie', 'avatar': Icons.person_outline},
      {'name': 'Diana', 'avatar': Icons.person_outline},
      {'name': 'Eve', 'avatar': Icons.person_outline},
      {'name': 'Frank', 'avatar': Icons.person_outline},
      {'name': 'Grace', 'avatar': Icons.person_outline},
      {'name': 'Henry', 'avatar': Icons.person_outline},
      {'name': 'Ivy', 'avatar': Icons.person_outline},
    ];

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Who's using Kidtastic?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Choose your profile or add a new student.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(bp),
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 3 / 4,
                        ),
                        delegate: SliverChildListDelegate(
                          [
                            ...students.map(
                              (s) => StudentCard(
                                name: s['name'] as String,
                                icon: s['avatar'] as IconData,
                              ),
                            ),
                            _AddStudentCard(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddStudentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => debugPrint('Add student clicked'),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('Add Student', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
