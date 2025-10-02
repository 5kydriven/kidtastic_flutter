import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/number_game/view/number_game_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants/constants.dart';
import 'package:kidtastic_flutter/pages/home/view/view.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final int totalItems = 50;
  final int itemsPerPage = 6;

  int get totalPages => (totalItems / itemsPerPage).ceil();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onArrowPressed(int newPage) {
    setState(() => currentPage = newPage);
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hello John Doe',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Let's play and learn",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      child: currentPage > 0
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () => _onArrowPressed(currentPage - 1),
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
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalPages,
                            onPageChanged: (index) {
                              setState(() => currentPage = index);
                            },
                            itemBuilder: (context, pageIndex) {
                              final start = pageIndex * itemsPerPage;
                              final end = (start + itemsPerPage) > totalItems
                                  ? totalItems
                                  : (start + itemsPerPage);
                              final items = List.generate(
                                end - start,
                                (i) => start + i,
                              );

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
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final itemIndex = items[index];
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(NumberGamePage.route);
                                      },
                                      child: SizedBox(
                                        width: 600,
                                        height: 600,
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
                                                  Assets.letters,
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 12,
                                                      ),
                                                  child: Text(
                                                    'Card ${itemIndex + 1}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                          controller: _pageController,
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
                      child: currentPage < totalPages - 1
                          ? IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () => _onArrowPressed(currentPage + 1),
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
