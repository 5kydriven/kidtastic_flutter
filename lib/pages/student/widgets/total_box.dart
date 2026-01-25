import 'package:flutter/material.dart';

class TotalBox extends StatelessWidget {
  final String label;
  final String total;

  const TotalBox({
    super.key,
    required this.label,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 238, 213),
            borderRadius: BorderRadius.circular(32),
            border: BoxBorder.all(
              color: Color(0xffDE7E00),
              width: 6,
            ),
          ),
          child: Center(
            child: Text(
              total,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xffCC0000),
              ),
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Center(
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 255, 160, 37),
                ),
              ),
              onPressed: null,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
