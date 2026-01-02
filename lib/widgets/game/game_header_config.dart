import 'package:flutter/widgets.dart';

class GameHeaderConfig {
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? center;
  final bool showSettings;
  final VoidCallback? onSettings;

  const GameHeaderConfig({
    this.showBack = false,
    this.onBack,
    this.center,
    this.showSettings = false,
    this.onSettings,
  });
}
