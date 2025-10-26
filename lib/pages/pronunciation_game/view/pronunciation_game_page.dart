import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';
import '../../../repositories/repositories.dart';
import '../../../services/services.dart';
import '../bloc/bloc.dart';
import 'view.dart';

class PronunciationGamePage extends StatefulWidget {
  static const String route = '/pronunciation-game';
  final PronunciationGameState initialState;

  const PronunciationGamePage({
    super.key,
    required this.initialState,
  });

  @override
  State<PronunciationGamePage> createState() => _PronunciationGamePageState();
}

class _PronunciationGamePageState extends State<PronunciationGamePage> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PronunciationGameBloc(
        initialState: widget.initialState,
        gameQuestionRepository: RepositoryProvider.of<GameQuestionRepository>(
          context,
        ),
        gameSessionRepository: RepositoryProvider.of<GameSessionRepository>(
          context,
        ),
        sessionQuestionRepository:
            RepositoryProvider.of<SessionQuestionRepository>(context),
        speechService: SpeechRecognitionService.instance,
        pronunciationAttemptRepository:
            RepositoryProvider.of<PronunciationAttemptRepository>(context),
      )..add(const PronunciationGameScreenCreated()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const PronunciationGameAppBar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.pronunciationBg,
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SizedBox(
                      width: constraints.maxWidth * 0.8,
                      height: constraints.maxHeight * 0.8,
                      child: const PronunciationGameBody(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
