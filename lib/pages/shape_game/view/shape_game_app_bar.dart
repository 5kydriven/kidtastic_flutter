import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';

class ShapeGameAppBar extends StatelessWidget {
  const ShapeGameAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit Game'),
                content: const Text(
                  'Are you sure you want to exit the game?',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                      context.pop();
                    },
                    child: const Text('Exit'),
                  ),
                ],
              );
            },
          );
        },
        child: Image.asset(
          Assets.arrowLeft,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
