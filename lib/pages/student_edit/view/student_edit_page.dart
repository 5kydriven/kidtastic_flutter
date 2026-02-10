import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../bloc/bloc.dart';
import 'view.dart';

class StudentEditPage extends StatelessWidget {
  static const String route = '/student/edit';
  final Student student;

  const StudentEditPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentEditBloc>(
      create: (context) => StudentEditBloc(
        studentRepository: context.read<StudentRepository>(),
      )..add(StudentEditScreenCreated(student: student)),
      child: BlocListener<StudentEditBloc, StudentEditState>(
        listenWhen: (previous, current) =>
            previous.studentRequestStatus != current.studentRequestStatus,
        listener: (context, state) {
          if (state.studentRequestStatus == RequestStatus.success) {
            context.pop();
          }
        },
        child: const StudentEditBody(),
      ),
    );
  }
}
