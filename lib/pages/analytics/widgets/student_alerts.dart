import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/state/analytics_state.dart';

import '../../../models/models.dart';

class StudentAlerts extends StatelessWidget {
  final StudentRanking student;
  final AlertType type;

  const StudentAlerts({
    super.key,
    required this.student,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: type == AlertType.lowPerformance
            ? Colors.red[50]
            : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: type == AlertType.lowPerformance
              ? Colors.red[200]!
              : Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: type == AlertType.lowPerformance
                ? Colors.red[100]
                : Colors.orange[100],
            backgroundImage: student.studentImage != null
                ? AssetImage(student.studentImage!)
                : null,
            child: student.studentImage == null
                ? Icon(
                    Icons.person,
                    size: 16,
                    color: type == AlertType.lowPerformance
                        ? Colors.red[600]
                        : Colors.orange[600],
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  type == AlertType.lowPerformance
                      ? 'Accuracy: ${student.averageAccuracy.toStringAsFixed(0)}%'
                      : 'Last active: ${student.totalSessions > 0 ? "${student.totalSessions} sessions total" : "Never played"}',
                  style: TextStyle(
                    fontSize: 11,
                    color: type == AlertType.lowPerformance
                        ? Colors.red[600]
                        : Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            type == AlertType.lowPerformance
                ? Icons.trending_down
                : Icons.schedule,
            size: 18,
            color: type == AlertType.lowPerformance
                ? Colors.red[400]
                : Colors.orange[400],
          ),
        ],
      ),
    );
  }
}
