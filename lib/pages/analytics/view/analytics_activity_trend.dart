import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/analytics/widgets/widgets.dart';

import '../bloc/bloc.dart';

class AnalyticsActivityTrend extends StatelessWidget {
  const AnalyticsActivityTrend({super.key});

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
                        return DayColumn(
                          day: day,
                          maxSessions: maxSessions,
                          availableWidth: constraints.maxWidth,
                        );
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
}
