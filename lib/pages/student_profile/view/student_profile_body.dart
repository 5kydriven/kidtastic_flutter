import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class StudentProfileBody extends StatelessWidget {
  const StudentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          color: const Color.fromARGB(255, 255, 238, 213),
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Alex Johnson',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.male, size: 18, color: Color(0xFF5D4037)),
                            Text(
                              ' Male',
                              style: TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.calendar_month, size: 18, color: Color(0xFF5D4037)),
                            Text(
                              ' Added: Jan 15, 2024',
                              style: TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, size: 18, color: Color(0xFF5D4037)),
                            Text(
                              ' Last played: Today, 2:30 PM',
                              style: TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'RECENT ACTIVITIES',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityCard('Tracing Letter', 'A', 0.75, Colors.blue),
                  _buildActivityCard('Counting Numbers', '1-10', 0.60, Colors.green),
                  _buildActivityCard('Colors', 'Red & Blue', 0.85, Colors.orange),
                  _buildActivityCard('Shapes', 'Circle & Square', 0.45, Colors.purple),
                  const SizedBox(height: 24),
                  const Text(
                    'PERFORMANCE SUMMARY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDonutChartSection(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -83,
          left: 70,
          child: Image.asset(
            Assets.adminOwl,
            width: 100,
            height: 100,
          ),
        ),
        Positioned(
          top: -68,
          left: 164,
          child: Image.asset(
            Assets.dashboard,
            width: 400,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String subtitle, double progress, Color progressColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getActivityIcon(title),
                  color: progressColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: TextStyle(
              fontSize: 12,
              color: progressColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartSection() {
    final skills = [
      {'name': 'Letter Tracing', 'progress': 0.75, 'color': Colors.blue},
      {'name': 'Number Counting', 'progress': 0.60, 'color': Colors.green},
      {'name': 'Color Recognition', 'progress': 0.85, 'color': Colors.orange},
      {'name': 'Shape Identification', 'progress': 0.45, 'color': Colors.purple},
    ];

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          value: 0.66,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          value: 0.55,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          value: 0.80,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ),
                    Center(
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
        ],
      ),
    );
  }

  IconData _getActivityIcon(String title) {
    switch (title) {
      case 'Tracing Letter':
        return Icons.edit_note;
      case 'Counting Numbers':
        return Icons.numbers;
      case 'Colors':
        return Icons.palette;
      case 'Shapes':
        return Icons.crop_square;
      default:
        return Icons.star;
    }
  }
}
