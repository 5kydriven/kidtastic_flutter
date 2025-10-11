import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  bool isMaximized = false;

  void _toggleMaximizeRestore() async {
    final maximized = await windowManager.isMaximized();
    if (maximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
    setState(() => isMaximized = !maximized);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: Container(
        height: 40,
        color: const Color(0xFFBC5D19),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Text(
              'Kidtastic',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _TitleBarButton(
              icon: Icons.remove,
              onPressed: () => windowManager.minimize(),
            ),
            _TitleBarButton(
              icon: isMaximized
                  ? Icons.crop_square
                  : Icons.check_box_outline_blank,
              onPressed: _toggleMaximizeRestore,
            ),
            _TitleBarButton(
              icon: Icons.close,
              onPressed: () => windowManager.close(),
              hoverColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;

  const _TitleBarButton({
    required this.icon,
    required this.onPressed,
    this.hoverColor = const Color(0x33FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 46,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
