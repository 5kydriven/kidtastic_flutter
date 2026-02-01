import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/student_profile/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';
import 'student_profile_header.dart';
import 'student_profile_recent_activities.dart';
import 'student_profile_performance_summary.dart';

class StudentProfilePage extends StatelessWidget {
  static const String route = '/student-profile';
  final StudentProfileState initialState;

  const StudentProfilePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileBloc(
        initialState: initialState,
      ),
      child: GameScaffold(
        contentPadding: EdgeInsets.only(
          top: 100,
          bottom: 52,
        ),
        imageAssets: Assets.adminBg,
        header: GameHeaderConfig(
          showBack: true,
          onBack: () => context.pop(),
        ),
        child: BodyContainer(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            color: const Color.fromARGB(255, 255, 238, 213),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StudentProfileHeader(),
                    SizedBox(
                      height: 32,
                    ),
                    StudentProfileRecentActivities(),
                    SizedBox(
                      height: 24,
                    ),
                    StudentProfilePerformanceSummary(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
