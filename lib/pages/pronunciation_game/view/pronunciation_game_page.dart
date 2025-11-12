import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
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
  final audioPlayer = AudioPlayer();
  final audioRecorder = AudioRecorder();
  final speechService = SpeechRecognitionService.instance;

  @override
  void initState() {
    super.initState();
    speechService.initialize();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  void _gameListener(BuildContext context, PronunciationGameState state) {
    final bloc = context.read<PronunciationGameBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: const Text('Choose another game'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                bloc.add(const PronunciationGameScreenCreated());
              },
              child: const Text('Play again'),
            ),
          ],
        );
      },
    );
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
        speechService: speechService,
        pronunciationAttemptRepository:
            RepositoryProvider.of<PronunciationAttemptRepository>(context),
      )..add(const PronunciationGameScreenCreated()),
      child: BlocListener<PronunciationGameBloc, PronunciationGameState>(
        listener: _gameListener,
        listenWhen: (previous, current) =>
            previous.gameSessionRequestStatus !=
                current.gameSessionRequestStatus &&
            current.gameSessionRequestStatus == RequestStatus.success,
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
      ),
    );
  }
}
