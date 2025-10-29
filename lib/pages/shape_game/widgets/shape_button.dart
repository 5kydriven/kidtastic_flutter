import 'package:flutter/material.dart';

class ShapeButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const ShapeButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<ShapeButton> createState() => _ShapeButtonState();
}

class _ShapeButtonState extends State<ShapeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),

        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (_isHovered) return const Color(0xffCF5961);
                return Colors.white;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (_isHovered) return Colors.white;
                return const Color(0xffCF5961);
              },
            ),
            side: WidgetStateProperty.all(
              BorderSide(
                color: _isHovered
                    ? const Color(0xffFFBF00)
                    : Colors.transparent,
                width: 4,
              ),
            ),
            elevation: WidgetStateProperty.all(
              _isHovered ? 14 : 8,
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            animationDuration: const Duration(milliseconds: 150),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
