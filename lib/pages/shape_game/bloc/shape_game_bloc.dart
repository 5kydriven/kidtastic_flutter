import 'package:bloc/bloc.dart';

import 'bloc.dart';

class ShapeGameBloc extends Bloc<ShapeGameEvent, ShapeGameState> {
  final ShapeGameState initialState;
  ShapeGameBloc({
    required this.initialState,
  }) : super(initialState);
}
