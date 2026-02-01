import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class StudentProfileRecentActivities extends StatelessWidget {
  const StudentProfileRecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT ACTIVITIES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        SizedBox(height: 16),
        ActivityProgressCard(
          title: 'Tracing Letter',
          subtitle: 'A',
          progress: 0.75,
          progressColor: Colors.blue,
        ),
        ActivityProgressCard(
          title: 'Counting Numbers',
          subtitle: '1-10',
          progress: 0.60,
          progressColor: Colors.green,
        ),
        ActivityProgressCard(
          title: 'Colors',
          subtitle: 'Red & Blue',
          progress: 0.85,
          progressColor: Colors.orange,
        ),
        ActivityProgressCard(
          title: 'Shapes',
          subtitle: 'Circle & Square',
          progress: 0.45,
          progressColor: Colors.purple,
        ),
      ],
    );
  }
}
