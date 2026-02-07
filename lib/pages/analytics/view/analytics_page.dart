import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/pages/analytics/bloc/bloc.dart';
import 'package:kidtastic_flutter/pages/analytics/view/view.dart';
import 'package:kidtastic_flutter/repositories/analytics_repository.dart';
import 'package:kidtastic_flutter/widgets/game/game.dart';

class AnalyticsPage extends StatefulWidget {
  static const route = '/analytics';

  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsBloc(
        initialState: const AnalyticsState(),
        analyticsRepository: RepositoryProvider.of<AnalyticsRepository>(
          context,
        ),
      )..add(const LoadAnalyticsOverview()),
      child: GameScaffold(
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

                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 8,
                      radius: const Radius.circular(8),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          const SliverPadding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: AnalyticsOverview(),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsetsGeometry.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: AnalyticsActivityTrend(),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsetsGeometry.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: AnalyticsTopPerforming(),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: SizedBox(
                                height: 270,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AnalyticsTopStudents(),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: AnalyticsNeedsAttention(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SliverPadding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: AnalyticsRecentActivity(),
                            ),
                          ),
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
      ),
    );
  }
}
