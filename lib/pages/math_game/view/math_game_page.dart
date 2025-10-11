import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/math_game/math_game.dart';
import 'package:kidtastic_flutter/pages/math_game/view/math_game_app_bar.dart';

import '../../../constants/constants.dart';

class MathGamePage extends StatelessWidget {
  static const route = '/math_game';

  const MathGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MathGameAppBar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.mathBg,
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.8,
                child: MathGameBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
