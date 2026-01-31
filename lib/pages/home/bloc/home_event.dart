sealed class HomeEvent {
  const HomeEvent();
}

class HomeScreenCreated extends HomeEvent {
  const HomeScreenCreated();
}

class HomeAddStudentPressed extends HomeEvent {
  const HomeAddStudentPressed();
}

class HomeFirstNameChanged extends HomeEvent {
  final String value;

  const HomeFirstNameChanged({
    required this.value,
  });
}

class HomeLastNameChanged extends HomeEvent {
  final String value;

  const HomeLastNameChanged({
    required this.value,
  });
}

class HomeDeleteStudentPressed extends HomeEvent {
  final int id;

  const HomeDeleteStudentPressed({
    required this.id,
  });
}

class HomeNextButtonPressed extends HomeEvent {
  const HomeNextButtonPressed();
}

class HomePrevButtonPressed extends HomeEvent {
  const HomePrevButtonPressed();
}

class HomeAvatarButtonPressed extends HomeEvent {
  const HomeAvatarButtonPressed();
}

class HomeAvatarSelected extends HomeEvent {
  final String avatar;

  const HomeAvatarSelected({
    required this.avatar,
  });
}

class HomeErrorTypeCleared extends HomeEvent {
  const HomeErrorTypeCleared();
}

class HomeSfxButtonPressed extends HomeEvent {
  const HomeSfxButtonPressed();
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

class HomeGenderChanged extends HomeEvent {
  final String value;

  const HomeGenderChanged({
    required this.value,
  });
}
