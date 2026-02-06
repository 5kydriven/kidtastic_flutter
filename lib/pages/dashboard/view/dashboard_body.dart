import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/analytics/view/analytics_page.dart';
import 'package:kidtastic_flutter/pages/dashboard/dashboard.dart';
import 'package:kidtastic_flutter/pages/login/view/login_page.dart';
import 'package:kidtastic_flutter/pages/student_list/view/student_list_page.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final bloc = context.read<DashboardBloc>();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color: const Color.fromARGB(255, 255, 238, 213),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 52,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HoverImageButton(
                        onTap: () {
                          bloc.add(const DashboardSfxButtonPressed());
                          context.push(AnalyticsPage.route);
                        },
                        child: Image.asset(
                          Assets.analyticsButton,
                          width: 232,
                          height: 232,
                        ),
                      ),
                      HoverImageButton(
                        onTap: () {
                          bloc.add(const DashboardSfxButtonPressed());
                          context.push(StudentListPage.route);
                        },
                        child: Image.asset(
                          Assets.studentButton,
                          width: 232,
                          height: 232,
                        ),
                      ),
                      HoverImageButton(
                        child: Image.asset(
                          Assets.settingsButtonV2,
                          width: 232,
                          height: 232,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     HoverImageButton(
                  //       child: Image.asset(
                  //         Assets.settingsButton,
                  //         width: 200,
                  //       ),
                  //     ),
                  HoverImageButton(
                    onTap: () {
                      bloc.add(const DashboardSfxButtonPressed());
                      context.go(LoginPage.route);
                    },
                    child: Image.asset(
                      Assets.logoutButton,
                      width: 200,
                    ),
                  ),
                  //   ],
                  // ),
                ],
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
        );
      },
    );
  }
}
