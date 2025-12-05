import '../../../models/models.dart';

sealed class MatchGameEvent {
  const MatchGameEvent();
}

class MatchGameScreenCreated extends MatchGameEvent {
  const MatchGameScreenCreated();
}

class MatchGameButtonPressed extends MatchGameEvent {
  final String answer;

  const MatchGameButtonPressed({
    required this.answer,
  });
}

class MatchGameQuestionNext extends MatchGameEvent {
  const MatchGameQuestionNext();
}

class MatchGameGameEnd extends MatchGameEvent {
  const MatchGameGameEnd();
}

class MatchGameItemDropped extends MatchGameEvent {
  final Question question;

  const MatchGameItemDropped({
    required this.question,
  });
}
