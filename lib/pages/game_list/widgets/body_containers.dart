import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;
  final String text;

  const BodyContainer({
    super.key,
    required this.child,
    required this.text,
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
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hi, $text!\n',
                  style: TextStyle(
                    fontFamily: 'Vag',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff02387A),
                  ),
                ),
                const TextSpan(
                  text: 'Select a game you want to play!',
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
