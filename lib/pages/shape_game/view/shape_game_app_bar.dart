import 'package:flutter/material.dart';

class ShapeGameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShapeGameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
    );
  }
}
