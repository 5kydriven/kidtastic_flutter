import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 52,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HoverImageButton(
                    child: Image.asset(
                      Assets.studentButton,
                      width: 232,
                      height: 232,
                    ),
                  ),
                  HoverImageButton(
                    child: Image.asset(
                      Assets.activitiesButton,
                      width: 232,
                      height: 232,
                    ),
                  ),
                  HoverImageButton(
                    child: Image.asset(
                      Assets.analyticsButton,
                      width: 232,
                      height: 232,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HoverImageButton(
                    child: Image.asset(
                      Assets.settingsButton,
                      width: 200,
                    ),
                  ),
                  HoverImageButton(
                    onTap: () => context.pop(),
                    child: Image.asset(
                      Assets.logoutButton,
                      width: 200,
                    ),
                  ),
                ],
              ),
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
  }
}
