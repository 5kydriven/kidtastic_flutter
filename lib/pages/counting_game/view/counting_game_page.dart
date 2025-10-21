import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/math_game/math_game.dart';

import '../../../constants/constants.dart';
import '../bloc/bloc.dart';

class CountingGamePage extends StatelessWidget {
  static const route = '/counting_game';
  final CountingGameState initialState;

  const CountingGamePage({
    super.key,
    required this.initialState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountingGameBloc(
        initialState: initialState,
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: MathGameAppBar(),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.mathBg,
                  fit: BoxFit.cover,
                ),
              ),

              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: MathGameBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
