import 'package:flutter/material.dart';

import '../../../models/models.dart';

class DayColumn extends StatelessWidget {
  final DailyActivity day;
  final int maxSessions;
  final double availableWidth;

  const DayColumn({
    super.key,
    required this.day,
    required this.maxSessions,
    required this.availableWidth,
  });

  @override
  Widget build(BuildContext context) {
    final heightPercentage = maxSessions > 0
        ? (day.sessionCount / maxSessions)
        : 0.0;

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
