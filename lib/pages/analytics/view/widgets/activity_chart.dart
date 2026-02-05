import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/bloc.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state.dailyActivity.isEmpty) {
          return const SizedBox.shrink();
        }

        final maxSessions = state.dailyActivity
            .map((d) => d.sessionCount)
            .reduce((a, b) => a > b ? a : b);

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.show_chart,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Activity Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Sessions over the last 7 days',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: state.dailyActivity.map((day) {
                        return _buildDayColumn(day, maxSessions, constraints.maxWidth);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayColumn(DailyActivity day, int maxSessions, double availableWidth) {
    // Ensure minimum bar height and calculate proportional height
    final heightPercentage = maxSessions > 0
        ? (day.sessionCount / maxSessions)
        : 0.0;
    
    // Minimum 15% height so even 0 shows a small bar, maximum 100%
    final normalizedHeight = 0.15 + (heightPercentage * 0.85);

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${day.sessionCount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Container(
              width: (availableWidth / 7) * 0.5,
              constraints: const BoxConstraints(
                minHeight: 10,
                maxHeight: 80,
              ),
              height: 80 * normalizedHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blue[400]!,
                    Colors.blue[300]!,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day.dayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
