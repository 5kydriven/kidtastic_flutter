import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  static const String route = '/splash';
  const SplashScreenPage({super.key});

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
