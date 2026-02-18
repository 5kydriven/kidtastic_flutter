sealed class TracingGameEvent {
  const TracingGameEvent();
}

class TracingGameScreenCreated extends TracingGameEvent {
  const TracingGameScreenCreated();
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
