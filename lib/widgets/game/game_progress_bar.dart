import 'package:flutter/material.dart';

class GameProgressBar extends StatelessWidget {
  final double value;

  const GameProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xffFFAE00),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          value: safeValue,
          backgroundColor: Colors.white,
          color: const Color(0xffFFC30E),
        ),
      ),
    );
  }
}
