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

class PronunciationGameBgmToggled extends PronunciationGameEvent {
  const PronunciationGameBgmToggled();
}

class PronunciationGameSfxToggled extends PronunciationGameEvent {
  const PronunciationGameSfxToggled();
}

class PronunciationGameBgmVolumeChanged extends PronunciationGameEvent {
  final double volume;

  const PronunciationGameBgmVolumeChanged({
    required this.volume,
  });
}

class PronunciationGameSfxVolumeChanged extends PronunciationGameEvent {
  final double volume;

  const PronunciationGameSfxVolumeChanged({
    required this.volume,
  });
}

class PronunciationGameSfxButtonPressed extends PronunciationGameEvent {
  const PronunciationGameSfxButtonPressed();
}
