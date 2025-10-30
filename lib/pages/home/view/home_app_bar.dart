import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: InkWell(
        onTap: () => context.pop(),
        child: Image.asset(
          Assets.arrowLeft,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
