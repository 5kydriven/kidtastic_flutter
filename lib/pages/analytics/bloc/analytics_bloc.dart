import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required AnalyticsState initialState,
  }) : super(initialState);
}
