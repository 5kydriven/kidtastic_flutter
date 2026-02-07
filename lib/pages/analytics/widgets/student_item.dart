import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/models/models.dart';

class StudentItem extends StatelessWidget {
  final StudentRanking student;

  const StudentItem({
    super.key,
    required this.student,
  });

  String _getMedalIcon(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank.';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[300]!;
      default:
        return Colors.transparent;
    }
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final isTopThree = student.rank <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isTopThree
            ? _getRankColor(student.rank).withValues(alpha: 0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: isTopThree
            ? Border.all(
                color: _getRankColor(student.rank).withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              _getMedalIcon(student.rank),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            backgroundImage: student.studentImage != null
                ? AssetImage(student.studentImage ?? '')
                : null,
            child: student.studentImage == null
                ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${student.totalSessions} sessions',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getAccuracyColor(
                student.averageAccuracy,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${student.averageAccuracy.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _getAccuracyColor(student.averageAccuracy),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
