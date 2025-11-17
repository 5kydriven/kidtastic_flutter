import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class PronunciationGameBody extends StatelessWidget {
  const PronunciationGameBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PronunciationGameBloc, PronunciationGameState>(
      builder: (context, state) {
        final bloc = context.read<PronunciationGameBloc>();
        final current = state.question.isNotEmpty
            ? state.question[state.currentIndex]
            : null;

        if (!state.isModelReady) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Initializing AI model...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              CircularProgressIndicator(),
            ],
          );
        }

        if (current == null) {
          return const Center(
            child: Text(
              'No question available',
              style: TextStyle(fontSize: 24, color: Colors.redAccent),
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Read and speak the sentence below:',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((current.image ?? '').isNotEmpty)
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          current.image!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) => const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      current.question ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Color(0xff09877D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Text(
              'You said: "${state.recognizedText}"',
              style: TextStyle(
                fontSize: 20,
                color: state.isCorrect ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => bloc.add(
                    PronunciationGameTextSpeech(
                      text: current.question ?? '',
                    ),
                  ),
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  label: const Text(
                    'Tap to listen',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isRecording
                        ? Colors.redAccent
                        : Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => state.isModelReady
                      ? bloc.add(const PronunciationGameRecordingToggle())
                      : null,
                  icon: Icon(
                    state.isRecording ? Icons.stop_circle_rounded : Icons.mic,
                    color: Colors.white,
                  ),
                  label: Text(
                    state.isRecording ? 'Listening...' : 'Tap to speak',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
