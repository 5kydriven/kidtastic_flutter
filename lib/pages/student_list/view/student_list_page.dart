import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/game/game.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../student_list.dart';

class StudentListPage extends StatelessWidget {
  static const String route = '/student_list';

  const StudentListPage({super.key});

  void _deleteStudentListener(
    BuildContext context,
    StudentListState state,
  ) {
    switch (state.studentRequestStatus) {
      case RequestStatus.inProgress:
        Center(
          child: CircularProgressIndicator(),
        );
        break;
      case RequestStatus.success:
        context.pop();
        break;
      case RequestStatus.failure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong please try again',
              style: const TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(
              milliseconds: 2500,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

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
      child: BlocConsumer<StudentListBloc, StudentListState>(
        listener: _deleteStudentListener,
        listenWhen: (previous, current) =>
            previous.studentRequestStatus != current.studentRequestStatus,
        builder: (context, state) {
          final bloc = context.read<StudentListBloc>();

          return GameScaffold(
            header: GameHeaderConfig(
              onBack: () {
                bloc.add(const StudentListSfxButtonPressed());
                context.pop();
              },
              showBack: true,
              showSettings: true,
              onSettings: () {
                bloc.add(const StudentListSfxButtonPressed());
                showDialog(
                  context: context,
                  builder: (_) => SizedBox(
                    child: StudentListSettingsDialog(
                      context: context,
                    ),
                  ),
                );
              },
            ),
            contentPadding: EdgeInsetsGeometry.only(
              top: 100,
              bottom: 52,
            ),
            imageAssets: Assets.adminBg,
            child: StudentListBody(),
          );
        },
      ),
    );
  }
}
