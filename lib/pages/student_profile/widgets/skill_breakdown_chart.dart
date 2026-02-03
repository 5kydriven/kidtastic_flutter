import 'package:flutter/material.dart';

class SkillBreakdownChart extends StatelessWidget {
  final List<SkillData> skills;

  const SkillBreakdownChart({
    super.key,
    required this.skills,
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
          const Text(
            'SKILL BREAKDOWN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  children: _buildDonutChart(),
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: skills.asMap().entries.map((entry) {
                    final index = entry.key;
                    final skill = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: skill.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              skill.name,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5D4037),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${skill.percentage.toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: skill.color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          _buildStatusIndicator(skill.percentage),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDonutChart() {
    if (skills.isEmpty) {
      return [
        Center(
          child: Text(
            'No Data',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ),
      ];
    }

    final List<Widget> rings = [];
    double startAngle = 0;

    // Sort skills by percentage (descending) for better visualization
    final sortedSkills = List<SkillData>.from(skills)
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    // Build concentric rings
    for (int i = 0; i < sortedSkills.length && i < 3; i++) {
      final skill = sortedSkills[i];
      final size = 120.0 - (i * 25);
      
      rings.add(
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: skill.percentage / 100,
              strokeWidth: 12,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(skill.color),
            ),
          ),
        ),
      );
    }

    // Add center text with average
    final average = skills.isEmpty
        ? 0.0
        : skills.fold<double>(0, (sum, s) => sum + s.percentage) / skills.length;

    rings.add(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${average.toInt()}%',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const Text(
              'Average',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );

    return rings;
  }

  Widget _buildStatusIndicator(double percentage) {
    IconData icon;
    Color color;
    
    if (percentage >= 80) {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (percentage >= 60) {
      icon = Icons.trending_up;
      color = Colors.orange;
    } else {
      icon = Icons.warning;
      color = Colors.red;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }
}

class SkillData {
  final String name;
  final double percentage;
  final Color color;

  const SkillData({
    required this.name,
    required this.percentage,
    required this.color,
  });
}
