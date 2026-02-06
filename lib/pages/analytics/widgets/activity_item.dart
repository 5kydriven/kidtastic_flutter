import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidtastic_flutter/models/models.dart';

class ActivityItem extends StatelessWidget {
  final RecentSession session;

  const ActivityItem({
    super.key,
    required this.session,
  });

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  Color _getScoreColor(int score, int total) {
    if (total == 0) return Colors.grey;
    final percentage = (score / total) * 100;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  IconData _getGameIcon(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'match the shapes':
        return Icons.category_rounded;
      case 'counting':
        return Icons.calculate_rounded;
      case 'pronunciation':
        return Icons.record_voice_over_rounded;
      default:
        return Icons.games_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: session.studentImage != null
                ? AssetImage(session.studentImage ?? '')
                : null,
            child: session.studentImage == null
                ? Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.grey[600],
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      _getGameIcon(session.gameName),
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.gameName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${session.score}/${session.totalQuestions}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(session.score, session.totalQuestions),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimeAgo(session.playedAt),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
