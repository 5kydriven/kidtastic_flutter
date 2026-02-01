import 'package:flutter/material.dart';

class StudentProfilePerformanceSummary extends StatelessWidget {
  const StudentProfilePerformanceSummary({super.key});

  Widget _donutChartSection() {
    final skills = [
      {'name': 'Letter Tracing', 'progress': 0.75, 'color': Colors.blue},
      {'name': 'Number Counting', 'progress': 0.60, 'color': Colors.green},
      {'name': 'Color Recognition', 'progress': 0.85, 'color': Colors.orange},
      {
        'name': 'Shape Identification',
        'progress': 0.45,
        'color': Colors.purple,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              children: [
                _progressRing(
                  size: 120,
                  value: 0.66,
                  color: Colors.orange,
                ),
                _progressRing(
                  size: 90,
                  value: 0.55,
                  color: Colors.blue,
                ),
                _progressRing(
                  size: 60,
                  value: 0.80,
                  color: Colors.green,
                ),
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '66%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                      Text(
                        'Overall',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: skill['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      skill['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${((skill['progress'] as double) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: skill['color'] as Color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _progressRing({
    required double size,
    required double value,
    required Color color,
  }) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 12,
          backgroundColor: Colors.grey[200],
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PERFORMANCE SUMMARY',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 16),
        _donutChartSection(),
      ],
    );
  }
}
