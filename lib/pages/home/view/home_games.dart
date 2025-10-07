import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/math_game/view/math_game_page.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/view/pronunciation_game_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants/constants.dart';
import '../bloc/bloc.dart';

class HomeGames extends StatelessWidget {
  final PageController pageController;

  const HomeGames({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final List<Game> games = [
          Game(
            title: 'Math Game',
            image: Assets.letters,
            route: MathGamePage.route,
          ),
          Game(
            title: 'Pronunciation Game',
            image: Assets.musicNotes,
            route: PronunciationGamePage.route,
          ),
          Game(
            title: 'Colors Game',
            image: Assets.letters,
            route: '/colors-game',
          ),
          Game(
            title: 'Shapes Game',
            image: Assets.shapes,
            route: '/shapes-game',
          ),
        ];

        final int itemsPerPage = 6;

        final totalPages = (games.length / itemsPerPage).ceil();
        final bloc = context.read<HomeBloc>();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              child: state.currentPage > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => bloc.add(HomePrevButtonPressed()),
                    )
                  : null,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 24,
              children: [
                SizedBox(
                  width: 550,
                  height: 360,
                  child: PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalPages,
                    onPageChanged: (index) {},
                    itemBuilder: (context, pageIndex) {
                      final start = pageIndex * itemsPerPage;
                      final end = (start + itemsPerPage) > games.length
                          ? games.length
                          : (start + itemsPerPage);
                      final pageItems = games.sublist(start, end);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pageItems.length,
                          itemBuilder: (context, index) {
                            final game = pageItems[index];
                            return GestureDetector(
                              onTap: () => context.push(game.route),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xffBC98C1),
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        game.image,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          game.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SmoothPageIndicator(
                  controller: pageController,
                  count: totalPages,
                  effect: const WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 8,
                    activeDotColor: Colors.deepPurple,
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 48,
              child: state.currentPage < totalPages - 1
                  ? IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => bloc.add(HomeNextButtonPressed()),
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class Game {
  final String title;
  final String image;
  final String route;

  const Game({
    required this.title,
    required this.image,
    required this.route,
  });
}
