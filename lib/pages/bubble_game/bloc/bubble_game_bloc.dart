import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class BubbleGameBloc extends Bloc<BubbleGameEvent, BubbleGameState> {
  BubbleGameBloc({required BubbleGameState initialState}) : super(initialState);
}
