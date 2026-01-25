import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

class StudentBody extends StatelessWidget {
  const StudentBody({super.key});

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

  Widget _tableRow({
    required BuildContext context,
    required String name,
    required String grade,
    required String status,
    required String avatar,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(
        right: 20,
        left: 8,
      ),
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
                  border: BoxBorder.all(
                    color: Colors.deepOrangeAccent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(avatar),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              _bodyCell(
                context: context,
                text: name,
                flex: 3,
              ),
              _bodyCell(
                context: context,
                text: grade,
                flex: 2,
              ),
              _bodyCell(
                context: context,
                text: status,
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyCell({
    required BuildContext context,
    required String text,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatLastPlayed(DateTime? lastPlayedAt) {
    if (lastPlayedAt == null) return 'Never played';

    final now = DateTime.now();
    final difference = now.difference(lastPlayedAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
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
                                    _headerCell(
                                      context: context,
                                      label: 'Name',
                                      flex: 3,
                                    ),
                                    _headerCell(
                                      context: context,
                                      label: 'Grade',
                                      flex: 2,
                                    ),
                                    _headerCell(
                                      context: context,
                                      label: 'Status',
                                      flex: 2,
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
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 4),
                                    itemBuilder: (context, index) {
                                      final student = state.students[index];
                                      return _tableRow(
                                        context: context,
                                        avatar: student.image ?? '',
                                        name: student.name ?? '',
                                        grade: 'Grade ${index % 6 + 1}',
                                        status:
                                            'Last played ${_formatLastPlayed(
                                              student.lastPlayedAt,
                                            )}',
                                        onTap: () {},
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
                                TotalBox(
                                  label: 'Total Students',
                                  total: state.students.length.toString(),
                                ),
                                TotalBox(
                                  label: 'Played Today',
                                  total: totalSessions.toString(),
                                ),
                                TotalBox(
                                  label: 'Male',
                                  total: totalMale.toString(),
                                ),
                                TotalBox(
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
