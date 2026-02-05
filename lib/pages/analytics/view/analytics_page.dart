import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/bloc.dart';
import 'package:kidtastic_flutter/repositories/analytics_repository.dart';
import 'package:kidtastic_flutter/widgets/game/game.dart';

import 'widgets/widgets.dart';

class AnalyticsPage extends StatelessWidget {
  static const route = '/analytics';

  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsBloc(
        initialState: const AnalyticsState(),
        analyticsRepository: RepositoryProvider.of<AnalyticsRepository>(
          context,
        ),
      )..add(const LoadAnalyticsOverview()),
      child: const _AnalyticsPageView(),
    );
  }
}

class _AnalyticsPageView extends StatelessWidget {
  const _AnalyticsPageView();

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      contentPadding: const EdgeInsets.only(
        top: 100,
        bottom: 52,
      ),
      header: GameHeaderConfig(
        showBack: true,
        onBack: () => context.pop(),
      ),
      imageAssets: Assets.adminBg,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 98, 13),
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color: const Color.fromARGB(255, 255, 238, 213),
              child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                builder: (context, state) {
                  if (state.screenRequestStatus == RequestStatus.inProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.screenRequestStatus == RequestStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Unable to load analytics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AnalyticsBloc>().add(
                                const LoadAnalyticsOverview(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const AnalyticsMetricsGrid(),
                        const SizedBox(height: 20),
                        const TopGamesChart(),
                        const SizedBox(height: 20),
                        const ActivityChart(),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              // Tablet/Desktop: Side by side
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: StudentLeaderboard(),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: AreasNeedingAttention(),
                                  ),
                                ],
                              );
                            }
                            // Mobile: Stacked
                            return Column(
                              children: [
                                StudentLeaderboard(),
                                SizedBox(height: 16),
                                AreasNeedingAttention(),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const RecentActivityList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
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
        ),
      ),
    );
  }
}
