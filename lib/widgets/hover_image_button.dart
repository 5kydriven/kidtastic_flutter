import 'package:flutter/material.dart';

class HoverImageButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Image child;

  const HoverImageButton({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  State<HoverImageButton> createState() => _HoverImageButtonState();
}

class _HoverImageButtonState extends State<HoverImageButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _hovered ? -8.0 : 0.0)
            ..scale(_hovered ? 1.05 : 1.0),
          child: widget.child,
        ),
      ),
    );
  }
}
