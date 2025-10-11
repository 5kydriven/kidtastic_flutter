import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class PronunciationGameBody extends StatelessWidget {
  const PronunciationGameBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              child: Text(
                'Read and speak the sentence below:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: Row(
              children: [
                Image.asset(
                  Assets.foxWearingNecktie,
                  fit: BoxFit.fill,
                  width: 300,
                  height: 300,
                ),
                Text(
                  'I\'m a fox wearing a necktie',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0xff09877D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
