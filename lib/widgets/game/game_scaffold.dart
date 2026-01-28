import 'package:flutter/material.dart';
import 'game_header.dart';
import 'game_header_config.dart';

class GameScaffold extends StatelessWidget {
  final String imageAssets;
  final Widget child;
  final GameHeaderConfig? header;
  final Widget? bottomBar;
  final double constraintsBox;
  final EdgeInsetsGeometry contentPadding;

  const GameScaffold({
    super.key,
    required this.imageAssets,
    required this.child,
    this.header,
    this.bottomBar,
    this.constraintsBox = 1400,
    this.contentPadding = const EdgeInsets.only(
      bottom: 24,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final widthFactor = size.width < 1400 ? 0.9 : 0.7;
    final heightFactor = size.height < 700 ? 0.9 : 0.8;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageAssets,
                fit: BoxFit.cover,
              ),
            ),

            if (header != null)
              Align(
                alignment: Alignment.topCenter,
                child: GameHeader(
                  config: header ?? GameHeaderConfig(),
                ),
              ),

            Padding(
              padding: contentPadding
                  .resolve(Directionality.of(context))
                  .copyWith(
                    top: header?.center != null ? 92 : null,
                  ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraintsBox,
                  ),
                  child: SizedBox(
                    width: size.width * widthFactor,
                    height: size.height * heightFactor,
                    child: child,
                  ),
                ),
              ),
            ),

            if (bottomBar != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: bottomBar ?? const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}
