import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/home/view/view.dart';

class HomePage extends StatelessWidget {
  static const route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: HomeAppBar(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              children: [
                Text('Hello John Doe'),
                Text('Let\'s play and learn'),

                HomeGames(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
