sealed class GameListEvent {
  const GameListEvent();
}

class GameListPrevButtonPressed extends GameListEvent {
  const GameListPrevButtonPressed();
}

class GameListNextButtonPressed extends GameListEvent {
  const GameListNextButtonPressed();
}

class GameListScreenCreated extends GameListEvent {
  const GameListScreenCreated();
}

class GameListBgmToggled extends GameListEvent {
  const GameListBgmToggled();
}

class GameListSfxToggled extends GameListEvent {
  const GameListSfxToggled();
}

class GameListBgmVolumeChanged extends GameListEvent {
  final double volume;

  const GameListBgmVolumeChanged({
    required this.volume,
  });
}

class GameListSfxVolumeChanged extends GameListEvent {
  final double volume;

  const GameListSfxVolumeChanged({
    required this.volume,
  });
}

class GameListSfxButtonPressed extends GameListEvent {
  const GameListSfxButtonPressed();
}

class GameListTutorialStarted extends GameListEvent {
  const GameListTutorialStarted();
}

class GameListTutorialNextPressed extends GameListEvent {
  const GameListTutorialNextPressed();
}

class GameListTutorialFinished extends GameListEvent {
  const GameListTutorialFinished();
}
