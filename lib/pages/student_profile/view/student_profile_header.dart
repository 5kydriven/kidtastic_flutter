import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/extensions/extentions.dart';

import '../bloc/bloc.dart';

class StudentProfileHeader extends StatelessWidget {
  const StudentProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentProfileBloc, StudentProfileState>(
      builder: (context, state) {
        final student = state.student;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                border: BoxBorder.all(
                  color: Colors.deepOrangeAccent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(student?.image ?? ''),
              ),
            ),
            Text(
              student?.name ?? '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  student?.gender == 'male' ? Icons.male : Icons.female,
                  size: 18,
                  color: Color(0xFF5D4037),
                ),
                Text(
                  student?.gender ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D4037),
                  ),
                ),
                SizedBox(width: 16),
                Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: Color(0xFF5D4037),
                ),
                Text(
                  ' Added: ${student?.createdAt?.toDateTimeString() ?? ''}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Color(0xFF5D4037),
                ),
                Text(
                  ' Last played: ${student?.lastPlayedAt.toLastPlayedString() ?? ''}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
