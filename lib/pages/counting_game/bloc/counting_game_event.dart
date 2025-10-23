abstract class CountingGameEvent {
  const CountingGameEvent();
}

class CountingGameScreenCreated extends CountingGameEvent {
  const CountingGameScreenCreated();
}

class CountingGameButtonPressed extends CountingGameEvent {
  final String answer;

  const CountingGameButtonPressed({
    required this.answer,
  });
}

class CountingGameNextQuestion extends CountingGameEvent {
  const CountingGameNextQuestion();
}

class CountingGameGameEnd extends CountingGameEvent {
  const CountingGameGameEnd();
}
