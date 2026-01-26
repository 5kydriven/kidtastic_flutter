abstract class InitialScreenEvent {
  const InitialScreenEvent();
}

class InitialScreenScreenCreated extends InitialScreenEvent {
  const InitialScreenScreenCreated();
}

class InitialScreenAddStudentPressed extends InitialScreenEvent {
  const InitialScreenAddStudentPressed();
}

class InitialScreenFirstNameChanged extends InitialScreenEvent {
  final String value;

  const InitialScreenFirstNameChanged({
    required this.value,
  });
}

class InitialScreenLastNameChanged extends InitialScreenEvent {
  final String value;

  const InitialScreenLastNameChanged({
    required this.value,
  });
}

class InitialScreenDeleteStudentPressed extends InitialScreenEvent {
  final int id;

  const InitialScreenDeleteStudentPressed({
    required this.id,
  });
}

class InitialScreenNextButtonPressed extends InitialScreenEvent {
  const InitialScreenNextButtonPressed();
}

class InitialScreenPrevButtonPressed extends InitialScreenEvent {
  const InitialScreenPrevButtonPressed();
}

class InitialScreenAvatarButtonPressed extends InitialScreenEvent {
  const InitialScreenAvatarButtonPressed();
}

class InitialScreenAvatarSelected extends InitialScreenEvent {
  final String avatar;

  const InitialScreenAvatarSelected({
    required this.avatar,
  });
}

class InitialScreenErrorTypeCleared extends InitialScreenEvent {
  const InitialScreenErrorTypeCleared();
}

class InitialScreenSfxButtonPressed extends InitialScreenEvent {
  const InitialScreenSfxButtonPressed();
}

class InitialScreenBgmToggled extends InitialScreenEvent {
  const InitialScreenBgmToggled();
}

class InitialScreenSfxToggled extends InitialScreenEvent {
  const InitialScreenSfxToggled();
}

class InitialScreenBgmVolumeChanged extends InitialScreenEvent {
  final double volume;

  const InitialScreenBgmVolumeChanged({
    required this.volume,
  });
}

class InitialScreenSfxVolumeChanged extends InitialScreenEvent {
  final double volume;

  const InitialScreenSfxVolumeChanged({
    required this.volume,
  });
}

class InitialScreenGenderChanged extends InitialScreenEvent {
  final String value;

  const InitialScreenGenderChanged({
    required this.value,
  });
}
