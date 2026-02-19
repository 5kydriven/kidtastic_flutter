sealed class TracingGameEvent {
  const TracingGameEvent();
}

class TracingGameScreenCreated extends TracingGameEvent {
  const TracingGameScreenCreated();
}

class TracingGameButtonPressed extends TracingGameEvent {
  final String answer;

  const TracingGameButtonPressed({
    required this.answer,
  });
}

class TracingGameNextQuestion extends TracingGameEvent {
  const TracingGameNextQuestion();
}

class TracingGameGameEnd extends TracingGameEvent {
  const TracingGameGameEnd();
}

class TracingGameBgmToggled extends TracingGameEvent {
  const TracingGameBgmToggled();
}

class TracingGameSfxToggled extends TracingGameEvent {
  const TracingGameSfxToggled();
}

class TracingGameBgmVolumeChanged extends TracingGameEvent {
  final double volume;

  const TracingGameBgmVolumeChanged({
    required this.volume,
  });
}

class TracingGameSfxVolumeChanged extends TracingGameEvent {
  final double volume;

  const TracingGameSfxVolumeChanged({
    required this.volume,
  });
}

class TracingGameSfxButtonPressed extends TracingGameEvent {
  const TracingGameSfxButtonPressed();
}
