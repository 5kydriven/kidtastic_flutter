import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
import '../../initial_screen/view/view.dart';
import '../bloc/bloc.dart';

class DashboardPage extends StatelessWidget {
  static const String route = '/dashboard';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        initialState: DashboardState(),
      ),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final bloc = context.read<DashboardBloc>();
          return GameScaffold(
            constraintsBox: 1920,
            // header: GameHeaderConfig(
            //   showBack: true,
            //   onBack: () {
            //     context.pop();
            //     // bloc.add(const HomeSfxButtonPressed());
            //   },
            // ),
            imageAssets: Assets.homeBg,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.dashboardLogo,
                        ),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('Home'),
                          onTap: () {
                            bloc.add(const DashboardSfxButtonPressed());
                            context.go(InitialScreenPage.route);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Students'),
                          onTap: () {
                            bloc.add(const DashboardSfxButtonPressed());
                            context.go(InitialScreenPage.route);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () {
                            bloc.add(const DashboardSfxButtonPressed());
                            context.go(InitialScreenPage.route);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Placeholder(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
