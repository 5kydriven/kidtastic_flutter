import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class PronunciationGamePage extends StatelessWidget {
  static const String route = '/pronunciation-game';
  const PronunciationGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.pronunciationBg,
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Pronunciation Game',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
