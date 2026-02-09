import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/color_game/bloc/bloc.dart';

class ColorGameBloc extends Bloc<ColorGameEvent, ColorGameState> {
  ColorGameBloc({
    required ColorGameState initialState,
  }) : super(initialState);
}
