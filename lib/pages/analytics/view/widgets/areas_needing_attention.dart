import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/bloc.dart';

class AreasNeedingAttention extends StatelessWidget {
  const AreasNeedingAttention({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        final hasLowPerformers = state.lowPerformingStudents.isNotEmpty;
        final hasInactive = state.inactiveStudents.isNotEmpty;

        if (!hasLowPerformers && !hasInactive) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange[600],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Needs Attention',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (hasLowPerformers) ...[
                _buildSectionTitle('Low Performing Students', Colors.red),
                const SizedBox(height: 8),
                ...state.lowPerformingStudents.map((student) => 
                  _buildStudentAlert(student, AlertType.lowPerformance),
                ),
                if (hasInactive) const SizedBox(height: 16),
              ],
              if (hasInactive) ...[
                _buildSectionTitle('Inactive Students (7+ days)', Colors.orange),
                const SizedBox(height: 8),
                ...state.inactiveStudents.map((student) => 
                  _buildStudentAlert(student, AlertType.inactive),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentAlert(StudentRanking student, AlertType type) {
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

enum AlertType {
  lowPerformance,
  inactive,
}
