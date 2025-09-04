import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/home/home.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const StudentCard({
    required this.name,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(HomePage.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 40, child: Icon(icon, size: 48)),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
