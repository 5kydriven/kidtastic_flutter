sealed class ColorGameEvent {
  const ColorGameEvent();
}

class ColorGameScreenCreated extends ColorGameEvent {
  const ColorGameScreenCreated();
}

class ColorGameButtonPressed extends ColorGameEvent {
  final String answer;

  const ColorGameButtonPressed({
    required this.answer,
  });
}

class ColorGameNextQuestion extends ColorGameEvent {
  const ColorGameNextQuestion();
}

class ColorGameGameEnd extends ColorGameEvent {
  const ColorGameGameEnd();
}

class ColorGameBgmToggled extends ColorGameEvent {
  const ColorGameBgmToggled();
}

class ColorGameSfxToggled extends ColorGameEvent {
  const ColorGameSfxToggled();
}

class ColorGameBgmVolumeChanged extends ColorGameEvent {
  final double volume;

  const ColorGameBgmVolumeChanged({
    required this.volume,
  });
}

class ColorGameSfxVolumeChanged extends ColorGameEvent {
  final double volume;

  const ColorGameSfxVolumeChanged({
    required this.volume,
  });
}

class ColorGameSfxButtonPressed extends ColorGameEvent {
  const ColorGameSfxButtonPressed();
}
