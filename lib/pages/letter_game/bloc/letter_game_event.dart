sealed class LetterGameEvent {
  const LetterGameEvent();
}

class LetterGameScreenCreated extends LetterGameEvent {
  const LetterGameScreenCreated();
}

class LetterGameTraceDone extends LetterGameEvent {
  const LetterGameTraceDone();
}

class LetterGameNextQuestion extends LetterGameEvent {
  const LetterGameNextQuestion();
}

class LetterGameGameEnd extends LetterGameEvent {
  const LetterGameGameEnd();
}

class LetterGameBgmToggled extends LetterGameEvent {
  const LetterGameBgmToggled();
}

class LetterGameSfxToggled extends LetterGameEvent {
  const LetterGameSfxToggled();
}

class LetterGameBgmVolumeChanged extends LetterGameEvent {
  final double volume;

  const LetterGameBgmVolumeChanged({
    required this.volume,
  });
}

class LetterGameSfxVolumeChanged extends LetterGameEvent {
  final double volume;

  const LetterGameSfxVolumeChanged({
    required this.volume,
  });
}

class LetterGameSfxButtonPressed extends LetterGameEvent {
  const LetterGameSfxButtonPressed();
}
