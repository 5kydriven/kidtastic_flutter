import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/counting_game/counting_game.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/pronunciation_game.dart';
import 'package:kidtastic_flutter/pages/shape_game/shape_game.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/constants.dart';
import '../bloc/bloc.dart';

class HomeBody extends StatelessWidget {
  final PageController pageController;
  const HomeBody({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final games = state.games;
        final int itemsPerPage = 6;
        final totalPages = (games.isEmpty)
            ? 1
            : (games.length / itemsPerPage).ceil();
        final bloc = context.read<HomeBloc>();

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello ${state.student?.firstName?.toUpperCase() ?? ''}!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Color(0xffA66609),
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Choose an activity to learn and play.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffA66609),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 48,
                  child: state.currentPage > 0
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () =>
                              bloc.add(const HomePrevButtonPressed()),
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
                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * itemsPerPage;
                          final end = (start + itemsPerPage > games.length)
                              ? games.length
                              : start + itemsPerPage;
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
                                return InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                  onTap: () {
                                    if (game.route?.isNotEmpty ?? false) {
                                      switch (game.category) {
                                        case GameType.counting:
                                          context.push(
                                            CountingGamePage.route,
                                            extra: CountingGameState(
                                              game: game,
                                              student: state.student,
                                            ),
                                          );
                                          break;
                                        case GameType.pronunciation:
                                          context.push(
                                            PronunciationGamePage.route,
                                            extra: PronunciationGameState(
                                              game: game,
                                              student: state.student,
                                            ),
                                          );
                                        case GameType.shape:
                                          context.push(
                                            ShapeGamePage.route,
                                            extra: ShapeGameState(
                                              game: game,
                                              student: state.student,
                                            ),
                                          );
                                        default:
                                          context.push(
                                            game.route ?? '',
                                            extra: game,
                                          );

                                          break;
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'This game has no route set.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      side: const BorderSide(
                                        color: Color(0xffFFAE00),
                                        width: 2,
                                      ),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            game.imageAsset ?? '',
                                            width: 80,
                                            height: 80,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    const Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: Text(
                                              game.name ?? '',
                                              textAlign: TextAlign.center,
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
            ),
          ],
        );
      },
    );
  }
}
