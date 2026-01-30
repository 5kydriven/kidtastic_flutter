import 'package:flutter/material.dart';

class InitialScreenPage extends StatelessWidget {
  static const String route = '/initial_screen';
  const InitialScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icon/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
