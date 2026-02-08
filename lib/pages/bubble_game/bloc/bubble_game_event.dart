sealed class BubbleGameEvent {
  const BubbleGameEvent();
}

class BubbleGameScreenCreated extends BubbleGameEvent {
  const BubbleGameScreenCreated();
}

class BubbleGameButtonPressed extends BubbleGameEvent {
  final String answer;

  const BubbleGameButtonPressed({
    required this.answer,
  });
}

class BubbleGameNextQuestion extends BubbleGameEvent {
  const BubbleGameNextQuestion();
}

class BubbleGameGameEnd extends BubbleGameEvent {
  const BubbleGameGameEnd();
}

class BubbleGamePositionsGenerated extends BubbleGameEvent {
  final int questionIndex;
  final double maxWidth;
  final double maxHeight;

  const BubbleGamePositionsGenerated({
    required this.questionIndex,
    required this.maxWidth,
    required this.maxHeight,
  });
}

class BubbleGameBgmToggled extends BubbleGameEvent {
  const BubbleGameBgmToggled();
}

class BubbleGameSfxToggled extends BubbleGameEvent {
  const BubbleGameSfxToggled();
}

class BubbleGameBgmVolumeChanged extends BubbleGameEvent {
  final double volume;

  const BubbleGameBgmVolumeChanged({
    required this.volume,
  });
}

class BubbleGameSfxVolumeChanged extends BubbleGameEvent {
  final double volume;

  const BubbleGameSfxVolumeChanged({
    required this.volume,
  });
}

class BubbleGameSfxButtonPressed extends BubbleGameEvent {
  const BubbleGameSfxButtonPressed();
}

class BubbleGameTextSpeech extends BubbleGameEvent {
  final String text;

  const BubbleGameTextSpeech({
    required this.text,
  });
}
