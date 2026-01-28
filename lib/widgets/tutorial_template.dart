import 'package:flutter/material.dart';

class TutorialTemplate extends StatelessWidget {
  final bool? isSkipButton;
  final String title;
  final String body;
  final VoidCallback? onPressed;
  final bool isFinal;
  final bool? isFinishCentered;
  const TutorialTemplate({
    super.key,
    required this.title,
    required this.body,
    this.onPressed,
    required this.isFinal,
    this.isFinishCentered = false,
    this.isSkipButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      width: MediaQuery.of(context).size.width - 80,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: (isFinishCentered ?? false)
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 16.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                body,

                textAlign: TextAlign.left,
              ),
            ),
          ),
          Visibility(
            visible: onPressed != null,
            child: ElevatedButton(
              onPressed: () async {
                onPressed?.call();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15.0),
                backgroundColor: isFinal
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    width: 1.5,
                    color: isFinal
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              child: Text(
                isFinal
                    ? 'finish'
                    : isSkipButton ?? false
                    ? 'Skip for now'
                    : 'got it',
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
