import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../student_profile.dart';

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
        contentPadding: EdgeInsets.symmetric(
          vertical: 100,
        ),
        imageAssets: Assets.adminBg,
        header: GameHeaderConfig(
          showBack: true,
          onBack: () => context.pop(),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 10, 98, 13),
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.all(12),
          child: StudentProfileBody(),
        ),
      ),
    );
  }
}
