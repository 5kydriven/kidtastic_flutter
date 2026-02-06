import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class AnalyticsTopStudents extends StatelessWidget {
  const AnalyticsTopStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StudentLeaderboard(),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: AreasNeedingAttention(),
        ),
      ],
    );
  }
}
