import 'package:flutter/material.dart';

class GameScaffold extends StatelessWidget {
  final String imageAssets;
  final Widget? appBar;
  final Widget child;

  const GameScaffold({
    super.key,
    required this.imageAssets,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double widthFactor = size.width < 1000 ? 0.9 : 0.7;
    double heightFactor = size.height < 700 ? 0.9 : 0.8;

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

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: appBar,
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: SizedBox(
                  width: size.width * widthFactor,
                  height: size.height * heightFactor,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
