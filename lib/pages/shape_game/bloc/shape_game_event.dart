sealed class ShapeGameEvent {
  const ShapeGameEvent();
}

class ShapeGameScreenCreated extends ShapeGameEvent {
  const ShapeGameScreenCreated();
}

class ShapeGameButtonPressed extends ShapeGameEvent {
  final String answer;

  const ShapeGameButtonPressed({
    required this.answer,
  });
}

class ShapeGameNextQuestion extends ShapeGameEvent {
  const ShapeGameNextQuestion();
}

class ShapeGameGameEnd extends ShapeGameEvent {
  const ShapeGameGameEnd();
}
