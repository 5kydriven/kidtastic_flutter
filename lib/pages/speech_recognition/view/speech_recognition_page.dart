import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/services.dart';
import '../../../widgets/widgets.dart';
import '../bloc/bloc.dart';

class SpeechRecognitionPage extends StatelessWidget {
  static const String route = '/SpeechRecognition';
  const SpeechRecognitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeechRecognitionBloc(
        speechService: SpeechRecognitionService.instance,
      )..add(const SpeechRecognitionGameStarted()),
      child: BlocBuilder<SpeechRecognitionBloc, SpeechRecognitionState>(
        builder: (context, state) {
          final bloc = context.read<SpeechRecognitionBloc>();

          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confidence: ${state.confidenceScore.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextDisplayWidget(
                    text: state.currentWord ?? '',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You said: ${state.recognizedText ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      color: state.isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ControlButtonsWidget(
                    isRecording: state.isRecording,
                    hasText: (state.recognizedText ?? '').isNotEmpty,
                    onToggleRecording: () =>
                        bloc.add(const SpeechRecognitionToggleRecording()),
                    onClearText: () =>
                        bloc.add(const SpeechRecognitionClearText()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        bloc.add(const SpeechRecognitionNextWord()),
                    child: const Text('Next Word'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
