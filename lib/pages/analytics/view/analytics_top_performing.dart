import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class AnalyticsTopPerforming extends StatelessWidget {
  const AnalyticsTopPerforming({super.key});

  Color _getGameColor(String gameName) {
    switch (gameName.toLowerCase()) {
      case 'match the shapes':
        return Colors.green[600]!;
      case 'counting':
        return Colors.orange[600]!;
      case 'pronunciation':
        return Colors.blue[600]!;
      default:
        return Colors.purple[600]!;
    }
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
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state.averageAccuracyByGame.isEmpty) {
          return const SizedBox.shrink();
        }

        final sortedGames = state.averageAccuracyByGame.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Performing Games',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...sortedGames.map((entry) {
                final percentage = entry.value.clamp(0, 100);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getGameIcon(entry.key),
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getGameColor(entry.key),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getGameColor(entry.key),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
