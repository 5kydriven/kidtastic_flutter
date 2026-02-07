import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../bubble_game.dart';

class BubbleGamePage extends StatelessWidget {
  static const route = '/bubble-game';
  final BubbleGameState initialState;

  const BubbleGamePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      constraintsBox: 800,
      header: GameHeaderConfig(
        showBack: true,
        onBack: () => context.pop(),
      ),
      imageAssets: Assets.bubbleBg,
      child: Card(
        child: Placeholder(),
      ),
    );
  }
}
