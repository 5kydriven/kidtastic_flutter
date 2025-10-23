import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kidtastic_flutter/pages/counting_game/bloc/bloc.dart';

import '../../../constants/constants.dart';

class CountingGameAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CountingGameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountingGameBloc, CountingGameState>(
      builder: (context, state) {
        final bloc = context.read<CountingGameBloc>();
        return AppBar(
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Exit Game'),
                    content: const Text(
                      'Are you sure you want to exit the game?',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          bloc.add(const CountingGameGameEnd());
                          context.pop();
                        },
                        child: const Text('Exit'),
                      ),
                    ],
                  );
                },
              );
            },
            customBorder: const CircleBorder(),
            child: Image.asset(
              Assets.arrowLeft,
              width: 64,
              height: 64,
            ),
          ),
        );
      },
    );
  }
}
