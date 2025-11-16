sealed class PronunciationGameEvent {
  const PronunciationGameEvent();
}

class PronunciationGameScreenCreated extends PronunciationGameEvent {
  const PronunciationGameScreenCreated();
}

class PronunciationGameQuestionNext extends PronunciationGameEvent {
  const PronunciationGameQuestionNext();
}

class PronunciationGameGameEnd extends PronunciationGameEvent {
  const PronunciationGameGameEnd();
}

class PronunciationGameTextRecognized extends PronunciationGameEvent {
  final String recognizedText;
  const PronunciationGameTextRecognized(this.recognizedText);
}

class PronunciationGameSessionFetched extends PronunciationGameEvent {
  const PronunciationGameSessionFetched();
}

class PronunciationGameRecordingToggle extends PronunciationGameEvent {
  const PronunciationGameRecordingToggle();
}

class PronunciationGameModelReady extends PronunciationGameEvent {
  const PronunciationGameModelReady();
}

class PronunciationGameTextSpeech extends PronunciationGameEvent {
  final String text;

  const PronunciationGameTextSpeech({
    required this.text,
  });
}
