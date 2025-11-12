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
