import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/bloc.dart';

import 'metric_card.dart';

class AnalyticsMetricsGrid extends StatelessWidget {
  const AnalyticsMetricsGrid({super.key});

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainingMinutes}m';
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            MetricCard(
              icon: Icons.people_rounded,
              label: 'Students',
              value: _formatNumber(state.totalStudents),
              change: state.studentsChange > 0 ? '+${state.studentsChange} today' : null,
              isPositive: true,
              color: Colors.blue,
            ),
            MetricCard(
              icon: Icons.sports_esports_rounded,
              label: 'Sessions',
              value: _formatNumber(state.totalSessions),
              change: state.sessionsChange > 0 ? '+${state.sessionsChange} today' : null,
              isPositive: true,
              color: Colors.orange,
            ),
            MetricCard(
              icon: Icons.schedule_rounded,
              label: 'Time Played',
              value: _formatDuration(state.totalMinutesPlayed),
              change: state.minutesChange > 0 ? '+${_formatDuration(state.minutesChange)}' : null,
              isPositive: true,
              color: Colors.green,
            ),
            MetricCard(
              icon: Icons.trending_up_rounded,
              label: 'Avg Accuracy',
              value: '${state.averageAccuracy.toStringAsFixed(0)}%',
              change: state.accuracyChange != 0
                  ? '${state.accuracyChange > 0 ? '+' : ''}${state.accuracyChange.toStringAsFixed(1)}%'
                  : null,
              isPositive: state.accuracyChange >= 0,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }
}
