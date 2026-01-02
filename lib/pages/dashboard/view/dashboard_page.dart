import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';

class DashboardPage extends StatelessWidget {
  static const String route = '/dashboard';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      header: GameHeaderConfig(
        showBack: true,
        onBack: () {
          context.pop();
          // bloc.add(const HomeSfxButtonPressed());
        },
      ),
      imageAssets: Assets.homeBg,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Placeholder(),
      ),
    );
  }
}
