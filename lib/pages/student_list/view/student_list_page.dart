import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/game/game.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../student_list.dart';

class StudentListPage extends StatelessWidget {
  static const String route = '/student_list';

  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentListBloc(
        initialState: StudentListState(),
        studentRepository: RepositoryProvider.of<StudentRepository>(context),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
      )..add(const StudentListScreenCreated()),
      child: GameScaffold(
        header: GameHeaderConfig(
          onBack: () => context.pop(),
          showBack: true,
          showSettings: true,
        ),
        contentPadding: EdgeInsetsGeometry.only(
          top: 100,
          bottom: 52,
        ),
        imageAssets: Assets.adminBg,
        child: StudentListBody(),
      ),
    );
  }
}
