import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/widgets/hover_image_button.dart';
import '../../constants/constants.dart';
import 'game_header_config.dart';

class GameHeader extends StatelessWidget {
  final GameHeaderConfig config;

  const GameHeader({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (!config.showBack && !config.showSettings && config.center == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: SizedBox(
        height: 100,
        child: Row(
          spacing: 16,
          children: [
            SizedBox(
              width: 100,
              child: config.showBack
                  ? HoverImageButton(
                      onTap: config.onBack,
                      child: Image.asset(Assets.arrowLeft),
                    )
                  : null,
            ),

            Expanded(
              child: Center(
                child: config.center ?? const SizedBox.shrink(),
              ),
            ),

            SizedBox(
              width: 100,
              child: config.showSettings
                  ? HoverImageButton(
                      onTap: config.onSettings,
                      child: Image.asset(
                        Assets.settingsIcon,
                        width: 68,
                        height: 68,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
