import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class StudentProfileRecent extends StatelessWidget {
  const StudentProfileRecent({super.key});

  String _getGameType(String gameName) {
    final name = gameName.toLowerCase();
    if (name.contains('count')) return 'counting';
    if (name.contains('pronunciation') || name.contains('speak')) {
      return 'pronunciation';
    }
    if (name.contains('match') || name.contains('shape')) return 'matching';
    return 'other';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileBloc, StudentProfileState>(
      builder: (context, state) {
        if (state.recentSessions.isEmpty) {
          return const RecentActivityTimeline(activities: []);
        }

        final activities = state.recentSessions.map((session) {
          // Find game name
          final game = state.games.firstWhere(
            (g) => g.id == session.gameId,
            orElse: () => const Game(name: 'Unknown Game'),
          );

          final totalQuestions = session.totalQuestions ?? 10;
          final correctAnswers = session.score ?? 0;
          final accuracy = totalQuestions > 0
              ? (correctAnswers / totalQuestions) * 100
              : 0.0;

          return ActivityItem(
            gameName: game.name ?? 'Unknown Game',
            gameType: _getGameType(game.name ?? ''),
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions,
            accuracy: accuracy,
            timestamp: session.endedAt ?? DateTime.now(),
            durationMinutes: 0, // Will be populated in Phase 3
          );
        }).toList();

        return RecentActivityTimeline(
          activities: activities,
        );
      },
    );
  }
}
