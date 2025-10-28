import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/shape_game/shape_game.dart';

import '../../../constants/constants.dart';
import '../bloc/bloc.dart';

class ShapeGamePage extends StatelessWidget {
  static const String route = '/shape-game';
  final ShapeGameState initialState;

  const ShapeGamePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.matchTheShape,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left shape
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: Card(
                          child: Center(child: Text('shape')),
                        ),
                      ),
                    ),

                    // Right side (grid + bottom rectangle)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // ✅ Use LayoutBuilder to compute available space for grid
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // compute spacing dynamically
                                const spacing = 12.0;
                                return Padding(
                                  padding: const EdgeInsets.all(spacing),
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: spacing,
                                          mainAxisSpacing: spacing,
                                          // ✅ compute aspect ratio based on available space
                                          childAspectRatio:
                                              (constraints.maxWidth / 2 -
                                                  spacing) /
                                              ((constraints.maxHeight -
                                                      spacing * 2) /
                                                  3),
                                        ),
                                    itemCount: 6,
                                    itemBuilder: (context, index) {
                                      final colors = [
                                        Colors.red,
                                        Colors.blue,
                                        Colors.green,
                                        Colors.yellow,
                                        Colors.orange,
                                        Colors.purple,
                                      ];
                                      return Container(color: colors[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Bottom rectangle
                          SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Card(
                              child: Center(child: Text('sample')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
