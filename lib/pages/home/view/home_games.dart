import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/number_game/view/view.dart';

import '../../../constants/constants.dart';

class HomeGames extends StatelessWidget {
  const HomeGames({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return InkWell(
            onTap: () {
              print('tapped');
              context.push(NumberGamePage.route);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Color(0xffBC98C1),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      Assets.letters,
                      width: 100,
                      height: 100,
                    ),
                  ),

                  Align(
                    alignment: AlignmentGeometry.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        'Card ${index + 1}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 10,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1, // square cards
      ),
    );
  }
}
