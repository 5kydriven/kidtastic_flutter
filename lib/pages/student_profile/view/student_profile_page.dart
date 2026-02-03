import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/student_profile/widgets/widgets.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../student_profile.dart';

class StudentProfilePage extends StatefulWidget {
  static const String route = '/student-profile';
  final StudentProfileState initialState;

  const StudentProfilePage({
    super.key,
    required this.initialState,
  });

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileBloc(
        initialState: widget.initialState,
        gameSessionRepository: context.read<GameSessionRepository>(),
        studentInsightRepository: context.read<StudentInsightRepository>(),
        gameRepository: context.read<GameRepository>(),
      )..add(const StudentProfileScreenCreated()),
      child: BlocBuilder<StudentProfileBloc, StudentProfileState>(
        builder: (context, state) {
          final bloc = context.read<StudentProfileBloc>();

          return GameScaffold(
            contentPadding: EdgeInsets.only(
              top: 100,
              bottom: 52,
            ),
            imageAssets: Assets.adminBg,
            header: GameHeaderConfig(
              showBack: true,
              onBack: () {
                bloc.add(const StudentProfileSfxButtonPressed());
                context.pop();
              },
            ),
            child: BodyContainer(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                color: const Color.fromARGB(255, 255, 238, 213),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(8),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.all(24),
                        sliver: SliverToBoxAdapter(
                          child: StudentProfileHeader(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.only(
                          left: 24,
                          right: 24,
                          bottom: 16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: StudentProfileStatistic(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.only(
                          left: 24,
                          right: 24,
                          bottom: 16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: StudentProfileSkills(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.only(
                          left: 24,
                          right: 24,
                          bottom: 16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: StudentProfileRecent(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.only(
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: StudentProfileImprovement(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
