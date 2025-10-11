import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';

class PronunciationGameAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PronunciationGameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: InkWell(
        onTap: () => context.pop(),
        customBorder: const CircleBorder(),
        child: Image.asset(
          Assets.arrowLeft,
          width: 64,
          height: 64,
        ),
      ),
    );
  }
}
