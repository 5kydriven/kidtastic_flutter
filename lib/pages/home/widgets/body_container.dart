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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -80,
          left: 108,
          child: Image.asset(
            Assets.bubbleTextV2,
            width: 352,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 10, 98, 13),
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.all(12),

          child: child,
        ),
        Positioned(
          top: -86,
          left: 70,
          child: Image.asset(
            Assets.adminOwl,
            width: 100,
            height: 100,
          ),
        ),
        Positioned(
          top: -64,
          left: 178,
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Hoot!\n',
                  style: TextStyle(
                    fontFamily: 'Vag',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff02387A),
                  ),
                ),
                TextSpan(
                  text: "Who's using Kidtastic?",
                  style: TextStyle(
                    fontFamily: 'Vag',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff02387A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
