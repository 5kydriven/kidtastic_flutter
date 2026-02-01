import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/models.dart';
import '../../game_list/game_list.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';
import 'view.dart';

class HomeBody extends StatelessWidget {
  final PageController pageController;

  const HomeBody({
    super.key,
    required this.pageController,
  });

  void _handleStudentCard(BuildContext context, Student student) {
    final bloc = context.read<HomeBloc>();
    bloc.add(const HomeSfxButtonPressed());
    context.push(
      GameListPage.route,
      extra: GameListState(
        student: student,
      ),
    );
  }

  void _handleAddStudentDialog(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    bloc.add(const HomeSfxButtonPressed());
    showDialog(
      context: context,
      builder: (context) => HomeAddStudentDialog(
        homeBloc: bloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();

        final students = state.students;
        final int itemsPerPage = 8;
        final totalItems = students.length + 1;
        final totalPages = (totalItems / itemsPerPage).ceil();

        return Card(
          elevation: 8,
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
                        onPressed: () => bloc.add(
                          const HomePrevButtonPressed(),
                        ),
                      )
                    : null,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  SizedBox(
                    width: 580,
                    height: 400,
                    child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: totalPages,
                      itemBuilder: (context, pageIndex) {
                        final start = pageIndex * itemsPerPage;
                        final end = (start + itemsPerPage > students.length)
                            ? students.length
                            : start + itemsPerPage;

                        final pageItems = students.sublist(start, end);

                        final showAddButton = pageIndex == totalPages - 1;

                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            scrollbars: false,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1 / 1.4,
                                ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: showAddButton
                                ? pageItems.length + 1
                                : pageItems.length,
                            itemBuilder: (context, index) {
                              if (index < pageItems.length) {
                                final student = pageItems[index];
                                return StudentCard(
                                  name: student.firstName ?? '',
                                  image: student.image ?? '',
                                  onTap: () =>
                                      _handleStudentCard(context, student),
                                  onPressed: () => bloc.add(
                                    HomeDeleteStudentPressed(
                                      id: student.id ?? 0,
                                    ),
                                  ),
                                );
                              }

                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () => _handleAddStudentDialog(context),
                                  child: const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          'Add Profile',
                                          style: TextStyle(
                                            fontSize: 18,
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
                        onPressed: () => bloc.add(
                          const HomeNextButtonPressed(),
                        ),
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
