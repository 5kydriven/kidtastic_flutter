import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/shape_game/shape_game.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';

class ShapeGamePage extends StatelessWidget {
  static const String route = '/shape-game';
  final ShapeGameState initialState;

  const ShapeGamePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      appBar: ShapeGameAppBar(),
      imageAssets: Assets.matchTheShape,
      child: ShapeGameBody(),
    );
  }
}
