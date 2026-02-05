import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/constants/constants.dart';
import 'package:kidtastic_flutter/widgets/game/game.dart';

class AnalyticsPage extends StatelessWidget {
  static const route = '/analytics';

  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      contentPadding: EdgeInsets.only(
        top: 100,
        bottom: 52,
      ),
      header: GameHeaderConfig(
        showBack: true,
        onBack: () => context.pop(),
      ),
      imageAssets: Assets.adminBg,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 98, 13),
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              color: const Color.fromARGB(255, 255, 238, 213),
              child: Placeholder(),
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
        ),
      ),
    );
  }
}
