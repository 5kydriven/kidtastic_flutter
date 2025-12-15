import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardState initialState;

  DashboardBloc({
    required this.initialState,
  }) : super(initialState);
}
