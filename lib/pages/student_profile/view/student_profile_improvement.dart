import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/extensions/extentions.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class StudentProfileImprovement extends StatelessWidget {
  const StudentProfileImprovement({super.key});

  String _getGameType(String gameName) {
    final name = gameName.toLowerCase();
    if (name.contains('count')) return 'counting';
    if (name.contains('pronunciation') || name.contains('speak')) {
      return 'pronunciation';
    }
    if (name.contains('match') || name.contains('shape')) return 'matching';
    return 'other';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'counting':
        return Icons.numbers;
      case 'pronunciation':
        return Icons.record_voice_over;
      case 'matching':
        return Icons.extension;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileBloc, StudentProfileState>(
      builder: (context, state) {
        final weaknesses = <WeaknessItem>[];

        for (final insight in state.gameInsights) {
          final percentage = insight.averageScore ?? 0;
          final game = state.games.firstWhere(
            (g) => g.id == insight.gameId,
            orElse: () => const Game(name: 'Unknown'),
          );

          if (percentage < 60) {
            weaknesses.add(
              WeaknessItem(
                title: '${game.name} Needs Practice',
                description: 'Performance below 60% - needs more practice',
                category: _getGameType(game.name ?? ''),
                severity: percentage < 50 ? 'high' : 'medium',
                metric: '${percentage.toInt()}%',
              ),
            );
          }
        }

        // Build recommendations based on weaknesses
        final recommendations = <RecommendationItem>[];

        if (weaknesses.isNotEmpty) {
          for (final weakness in weaknesses.take(2)) {
            recommendations.add(
              RecommendationItem(
                title: 'Practice ${weakness.category.capitalize()}',
                description: 'Focus on ${weakness.category} exercises',
                icon: _getCategoryIcon(weakness.category),
              ),
            );
          }
        }

        return AreasForImprovement(
          weaknesses: weaknesses,
          recommendations: recommendations,
        );
      },
    );
  }
}
