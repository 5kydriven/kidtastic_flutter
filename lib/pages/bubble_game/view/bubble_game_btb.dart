import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class BubbleGameBtb extends StatelessWidget {
  const BubbleGameBtb({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleGameBloc, BubbleGameState>(
      builder: (context, state) {
        final bloc = context.read<BubbleGameBloc>();
        final question = state.question[state.currentIndex];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () => bloc.add(
                BubbleGameTextSpeech(
                  text: question.question ?? '',
                ),
              ),
              child: Text('Tap to listen'),
            ),
          ],
        );
      },
    );
  }
}
