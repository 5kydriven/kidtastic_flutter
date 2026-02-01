import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;

  const BodyContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child,
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
    );
  }
}
