import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/extensions/extentions.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../student_edit/student_edit.dart';
import '../../student_profile/student_profile.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class StudentListBody extends StatelessWidget {
  const StudentListBody({super.key});

  Widget _headerCell({
    required BuildContext context,
    required String label,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _studentRow({
    required BuildContext context,
    required Student student,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    final bloc = context.read<StudentListBloc>();

    return Material(
      color: Colors.white, // default background
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        hoverColor: const Color(0xFFFFE0B2), // light orange hover
        splashColor: const Color(0xFFFFCC80),
        highlightColor: const Color(0xFFFFE0B2),
        onTap: () {
          bloc.add(const StudentListSfxButtonPressed());
          context.push(
            StudentProfilePage.route,
            extra: StudentProfileState(student: student),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              /// NAME
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.deepOrangeAccent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(student.image ?? ''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        student.name?.capitalize() ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              /// GENDER
              Expanded(
                flex: 2,
                child: Text(
                  student.gender?.capitalize() ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),

              /// STATUS
              Expanded(
                flex: 2,
                child: Text(
                  'Last played ${student.lastPlayedAt.toLastPlayedString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: PopupMenuButton<String>(
                  onOpened: () => bloc.add(const StudentListSfxButtonPressed()),
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      bloc.add(const StudentListSfxButtonPressed());
                      context.push(
                        StudentEditPage.route,
                        extra: student,
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Row(
                              children: const [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(width: 8),
                                Text('Delete Student'),
                              ],
                            ),
                            content: const Text(
                              'Are you sure you want to delete this student? '
                              'This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => context.pop(),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentListBloc, StudentListState>(
      builder: (context, state) {
        final totalMale = state.students
            .where((e) => e.gender?.toLowerCase() == 'male')
            .length;
        final totalFemale = state.students
            .where((e) => e.gender?.toLowerCase() == 'female')
            .length;

        final totalSessions = state.gameSessions.length;

        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 10, 98, 13),
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.all(12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,

                color: const Color.fromARGB(255, 255, 238, 213),
                child: SizedBox(
                  height: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'LIST OF STUDENTS',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffDE7E00),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  bottom: 4,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 238, 213),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12.0,
                                        ),
                                        child: Text(
                                          'Name',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _headerCell(
                                      context: context,
                                      label: 'Gender',
                                      flex: 2,
                                    ),
                                    _headerCell(
                                      context: context,
                                      label: 'Status',
                                      flex: 2,
                                    ),
                                    _headerCell(
                                      context: context,
                                      label: 'Actions',
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),

                              Theme(
                                data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                      Color(0xffA97900),
                                    ),
                                    trackColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    trackBorderColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                    thickness: WidgetStateProperty.all(8),
                                    radius: const Radius.circular(8),
                                    thumbVisibility: WidgetStateProperty.all(
                                      true,
                                    ),
                                    trackVisibility: WidgetStateProperty.all(
                                      true,
                                    ),
                                  ),
                                ),
                                child: Expanded(
                                  child: ListView.separated(
                                    itemCount: state.students.length,
                                    separatorBuilder: (_, __) => const SizedBox(
                                      height: 4,
                                    ),
                                    itemBuilder: (context, index) {
                                      final student = state.students[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: _studentRow(
                                          context: context,
                                          student: student,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StudentListTotalBox(
                                  label: 'Total Students',
                                  total: state.students.length.toString(),
                                ),
                                StudentListTotalBox(
                                  label: 'Played Today',
                                  total: totalSessions.toString(),
                                ),
                                StudentListTotalBox(
                                  label: 'Male',
                                  total: totalMale.toString(),
                                ),
                                StudentListTotalBox(
                                  label: 'Female',
                                  total: totalFemale.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: -82,
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
        );
      },
    );
  }
}
