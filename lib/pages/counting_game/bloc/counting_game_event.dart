abstract class CountingGameEvent {
  const CountingGameEvent();
}

class CountingGameScreenCreated extends CountingGameEvent {
  const CountingGameScreenCreated();
}

class CountingGameButtonPressed extends CountingGameEvent {
  final String answer;

  const CountingGameButtonPressed({
    required this.answer,
  });
}

class CountingGameNextQuestion extends CountingGameEvent {
  const CountingGameNextQuestion();
}

class CountingGameGameEnd extends CountingGameEvent {
  const CountingGameGameEnd();
}

class CountingGamePositionsGenerated extends CountingGameEvent {
  final int questionIndex;
  final double maxWidth;
  final double maxHeight;

  const CountingGamePositionsGenerated({
    required this.questionIndex,
    required this.maxWidth,
    required this.maxHeight,
  });
}

class CountingGameBgmToggled extends CountingGameEvent {
  const CountingGameBgmToggled();
}

class CountingGameSfxToggled extends CountingGameEvent {
  const CountingGameSfxToggled();
}

class CountingGameBgmVolumeChanged extends CountingGameEvent {
  final double volume;

  const CountingGameBgmVolumeChanged({
    required this.volume,
  });
}

class CountingGameSfxVolumeChanged extends CountingGameEvent {
  final double volume;

  const CountingGameSfxVolumeChanged({
    required this.volume,
  });
}

class CountingGameSfxButtonPressed extends CountingGameEvent {
  const CountingGameSfxButtonPressed();
}
