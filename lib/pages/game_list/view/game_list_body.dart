import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/bubble_game/bubble_game.dart';
import 'package:kidtastic_flutter/pages/counting_game/counting_game.dart';
import 'package:kidtastic_flutter/pages/game_list/view/view.dart';
import 'package:kidtastic_flutter/pages/pronunciation_game/pronunciation_game.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../color_game/color_game.dart';
import '../../match_game/match_game.dart';
import '../bloc/bloc.dart';

class GameListBody extends StatelessWidget {
  final PageController pageController;
  const GameListBody({
    super.key,
    required this.pageController,
  });

  void _handleGameRoute(BuildContext context, Game game) {
    final bloc = context.read<GameListBloc>();
    final state = bloc.state;

    bloc.add(const GameListSfxButtonPressed());
    if (game.route?.isEmpty ?? true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'This game has no route set.',
          ),
        ),
      );
      return;
    }

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
          MatchGamePage.route,
          extra: MatchGameState(
            game: game,
            student: state.student,
          ),
        );
      case GameType.matching:
        context.push(
          MatchGamePage.route,
          extra: MatchGameState(
            game: game,
            student: state.student,
          ),
        );
      case GameType.bubble:
        context.push(
          BubbleGamePage.route,
          extra: BubbleGameState(
            game: game,
            student: state.student,
          ),
        );
      case GameType.color:
        context.push(
          ColorGamePage.route,
          extra: ColorGameState(
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameListBloc, GameListState>(
      builder: (context, state) {
        final games = state.games;
        final int itemsPerPage = 6;
        final totalPages = (games.isEmpty)
            ? 1
            : (games.length / itemsPerPage).ceil();
        final bloc = context.read<GameListBloc>();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                child: state.currentPage > 0
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () =>
                            bloc.add(const GameListPrevButtonPressed()),
                      )
                    : null,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  Container(
                    width: 624,
                    height: 412,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: totalPages,
                      itemBuilder: (context, pageIndex) {
                        final start = pageIndex * itemsPerPage;
                        final end = (start + itemsPerPage > games.length)
                            ? games.length
                            : start + itemsPerPage;
                        final pageItems = games.sublist(start, end);

                        return GridView.builder(
                          key: gameListGamesKey,
                          clipBehavior: Clip.none,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 172 / 172,
                              ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pageItems.length,
                          itemBuilder: (context, index) {
                            final game = pageItems[index];

                            return HoverImageButton(
                              onTap: () => _handleGameRoute(context, game),
                              child: Image.asset(
                                game.imageAsset ?? '',
                                height: 152,
                                width: 152,
                                fit: BoxFit.fill,
                              ),
                            );
                          },
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
                        onPressed: () => bloc.add(GameListNextButtonPressed()),
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
