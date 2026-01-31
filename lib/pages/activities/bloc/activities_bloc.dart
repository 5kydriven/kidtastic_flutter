import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc({
    required ActivitiesState initialState,
  }) : super(initialState);
}
