import 'package:flutter/material.dart';

class FloatingImageButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const FloatingImageButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<FloatingImageButton> createState() => _FloatingImageButtonState();
}

class _FloatingImageButtonState extends State<FloatingImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    )..repeat(reverse: true);

    _floatAnimation =
        Tween<double>(
          begin: 0,
          end: -12, // how high it levitates
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _floatAnimation.value + (_isHovered ? -6 : 0),
              ),
              child: AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
