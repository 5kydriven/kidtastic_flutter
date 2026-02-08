sealed class InitialScreenEvent {
  const InitialScreenEvent();
}

class InitialScreenCreated extends InitialScreenEvent {
  const InitialScreenCreated();
}

class InitialScreenSfxButtonPressed extends InitialScreenEvent {
  const InitialScreenSfxButtonPressed();
}
