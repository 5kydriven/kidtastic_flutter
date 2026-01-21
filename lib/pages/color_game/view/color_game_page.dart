import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';

GlobalKey sampleKey = GlobalKey();

class ColorGamePage extends StatefulWidget {
  static const route = '/color-game';

  const ColorGamePage({super.key});

  @override
  State<ColorGamePage> createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createTutorial();
      showTutorial();
    });
  }

  void showTutorial() {
    tutorialCoachMark.show(
      context: context,
    );
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      opacityShadow: 0.5,
      paddingFocus: 0,
      pulseEnable: false,
      hideSkip: true,
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: 'sampleKey',
        keyTarget: sampleKey,
        shape: ShapeLightFocus.RRect,
        radius: 18,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.05,
            ),
            builder: (_, __) {
              return const OwlGuideTemplate(
                message:
                    'Tap this button to start! test one two three eleven three',
              );
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      imageAssets: Assets.colorBg,
      child: Center(
        child: ElevatedButton(
          key: sampleKey,
          onPressed: () {},
          child: const Text('Start'),
        ),
      ),
    );
  }
}
