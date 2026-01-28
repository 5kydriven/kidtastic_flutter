sealed class HomeEvent {
  const HomeEvent();
}

class HomePrevButtonPressed extends HomeEvent {
  const HomePrevButtonPressed();
}

class HomeNextButtonPressed extends HomeEvent {
  const HomeNextButtonPressed();
}

class HomeScreenCreated extends HomeEvent {
  const HomeScreenCreated();
}

class HomeBgmToggled extends HomeEvent {
  const HomeBgmToggled();
}

class HomeSfxToggled extends HomeEvent {
  const HomeSfxToggled();
}

class HomeBgmVolumeChanged extends HomeEvent {
  final double volume;

  const HomeBgmVolumeChanged({
    required this.volume,
  });
}

class HomeSfxVolumeChanged extends HomeEvent {
  final double volume;

  const HomeSfxVolumeChanged({
    required this.volume,
  });
}

class HomeSfxButtonPressed extends HomeEvent {
  const HomeSfxButtonPressed();
}

class HomeTutorialStarted extends HomeEvent {
  const HomeTutorialStarted();
}

class HomeTutorialNextPressed extends HomeEvent {
  const HomeTutorialNextPressed();
}

class HomeTutorialFinished extends HomeEvent {
  const HomeTutorialFinished();
}
