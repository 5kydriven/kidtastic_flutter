import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/pages/initial_screen/view/view.dart';

class InitialScreenPage extends StatelessWidget {
  static const route = '/initial_screen';

  const InitialScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          child: Row(
            children: [
              FilledButton(
                onPressed: () {},
                child: Text('Teacher'),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 0,
            ),
            const InitialScreenHeader(),

            Container(
              width: 800,
              height: 500,

              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: InitialScreenBody(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
