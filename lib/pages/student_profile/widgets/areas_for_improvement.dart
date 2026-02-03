import 'package:flutter/material.dart';

class AreasForImprovement extends StatelessWidget {
  final List<WeaknessItem> weaknesses;
  final List<RecommendationItem> recommendations;

  const AreasForImprovement({
    super.key,
    required this.weaknesses,
    required this.recommendations,
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
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'AREAS FOR IMPROVEMENT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (weaknesses.isEmpty && recommendations.isEmpty)
            _buildAllGoodState()
          else ...[
            if (weaknesses.isNotEmpty) ...[
              _buildWeaknessesSection(),
              const SizedBox(height: 16),
            ],
            if (recommendations.isNotEmpty) _buildRecommendationsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildAllGoodState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Great job!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Keep practicing to maintain your progress!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Focus Areas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...weaknesses.map((weakness) => _buildWeaknessItem(weakness)),
      ],
    );
  }

  Widget _buildWeaknessItem(WeaknessItem weakness) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSeverityColor(weakness.severity).withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getSeverityColor(weakness.severity).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getSeverityColor(weakness.severity).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(weakness.category),
              color: _getSeverityColor(weakness.severity),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weakness.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  weakness.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getSeverityColor(weakness.severity).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              weakness.metric,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _getSeverityColor(weakness.severity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...recommendations.map((rec) => _buildRecommendationItem(rec)),
      ],
    );
  }

  Widget _buildRecommendationItem(RecommendationItem rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              rec.icon,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rec.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (rec.actionLabel != null)
            TextButton(
              onPressed: rec.onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                rec.actionLabel!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'counting':
      case 'numbers':
        return Icons.numbers;
      case 'pronunciation':
      case 'phonics':
        return Icons.record_voice_over;
      case 'matching':
      case 'shapes':
        return Icons.extension;
      case 'difficulty':
        return Icons.trending_up;
      case 'consistency':
        return Icons.calendar_today;
      default:
        return Icons.school;
    }
  }
}

class WeaknessItem {
  final String title;
  final String description;
  final String category;
  final String severity;
  final String metric;

  const WeaknessItem({
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.metric,
  });
}

class RecommendationItem {
  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const RecommendationItem({
    required this.title,
    required this.description,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });
}
