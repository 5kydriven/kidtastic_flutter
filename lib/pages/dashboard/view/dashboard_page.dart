import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/dashboard/view/dashboard_body.dart';
import 'package:kidtastic_flutter/widgets/widgets.dart';

import '../../../constants/constants.dart';
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
      child: GameScaffold(
        contentPadding: EdgeInsets.symmetric(
          vertical: 100,
        ),
        imageAssets: Assets.adminBg,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 10, 98, 13),
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.all(12),
          child: DashboardBody(),
        ),
      ),
    );
  }
}
