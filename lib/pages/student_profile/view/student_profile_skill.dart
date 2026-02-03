import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class StudentProfileSkills extends StatelessWidget {
  const StudentProfileSkills({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileBloc, StudentProfileState>(
      builder: (context, state) {
        if (state.gameInsights.isEmpty) {
          return const SizedBox.shrink();
        }

        final skills = state.gameInsights.map((insight) {
          final game = state.games.firstWhere(
            (g) => g.id == insight.gameId,
            orElse: () => const Game(name: 'Unknown'),
          );

          final percentage = insight.averageScore ?? 0;
          final color = percentage >= 80
              ? Colors.green
              : percentage >= 60
              ? Colors.orange
              : Colors.red;

          return SkillData(
            name: game.name ?? 'Unknown',
            percentage: percentage,
            color: color,
          );
        }).toList();

        return SkillBreakdownChart(
          skills: skills,
        );
      },
    );
  }
}
