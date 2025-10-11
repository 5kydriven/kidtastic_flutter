import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import 'view.dart';

class PronunciationGamePage extends StatelessWidget {
  static const String route = '/pronunciation-game';
  const PronunciationGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PronunciationGameAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.pronunciationBg,
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
              child: PronunciationGameBody(),
            ),
          ),
        ],
      ),
    );
  }
}
