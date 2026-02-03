import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/extensions/extentions.dart';

class RecentActivityTimeline extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivityTimeline({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              if (activities.isNotEmpty)
                Text(
                  '${activities.length} sessions',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (activities.isEmpty)
            _buildEmptyState()
          else
            ...activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;
              return _buildActivityItem(activity, isLast);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.videogame_asset_outlined,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Text(
            'No activities yet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start playing games to see progress!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getScoreColor(activity.accuracy),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[200],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Activity content
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Game icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _getGameColor(activity.gameType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getGameIcon(activity.gameType),
                      color: _getGameColor(activity.gameType),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Activity details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.gameName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${activity.correctAnswers}/${activity.totalQuestions} correct',
                          style: TextStyle(
                            fontSize: 13,
                            color: _getScoreColor(activity.accuracy),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              activity.timestamp.toLastPlayedString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            if (activity.durationMinutes > 0) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.timer,
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${activity.durationMinutes}m',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Accuracy badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(activity.accuracy).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${activity.accuracy.toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(activity.accuracy),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getGameColor(String gameType) {
    switch (gameType.toLowerCase()) {
      case 'counting':
        return Colors.blue;
      case 'pronunciation':
        return Colors.purple;
      case 'matching':
      case 'match':
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  IconData _getGameIcon(String gameType) {
    switch (gameType.toLowerCase()) {
      case 'counting':
        return Icons.numbers;
      case 'pronunciation':
        return Icons.record_voice_over;
      case 'matching':
      case 'match':
        return Icons.extension;
      default:
        return Icons.games;
    }
  }
}

class ActivityItem {
  final String gameName;
  final String gameType;
  final int correctAnswers;
  final int totalQuestions;
  final double accuracy;
  final DateTime timestamp;
  final int durationMinutes;

  const ActivityItem({
    required this.gameName,
    required this.gameType,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.accuracy,
    required this.timestamp,
    this.durationMinutes = 0,
  });
}
