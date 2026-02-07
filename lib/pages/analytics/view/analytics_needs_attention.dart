import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class AnalyticsNeedsAttention extends StatelessWidget {
  const AnalyticsNeedsAttention({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        final hasLowPerformers = state.lowPerformingStudents.isNotEmpty;
        final hasInactive = state.inactiveStudents.isNotEmpty;

        if (!hasLowPerformers && !hasInactive) {
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
                      color: Colors.green[600],
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
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'All students are doing great!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No students need attention at this time.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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
                SectionTile(
                  title: 'Low Performing Students',
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                ...state.lowPerformingStudents.map(
                  (student) =>
                      StudentAlerts(student: student, type: AlertType.lowPerformance),
                ),
                if (hasInactive) const SizedBox(height: 16),
              ],
              if (hasInactive) ...[
                SectionTile(
                  title: 'Inactive Students (7+ days)',
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                ...state.inactiveStudents.map(
                  (student) => StudentAlerts(student: student, type: AlertType.inactive),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
