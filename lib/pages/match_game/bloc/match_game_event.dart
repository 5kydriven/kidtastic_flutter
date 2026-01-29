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

class MatchGameBgmToggled extends MatchGameEvent {
  const MatchGameBgmToggled();
}

class MatchGameSfxToggled extends MatchGameEvent {
  const MatchGameSfxToggled();
}

class MatchGameBgmVolumeChanged extends MatchGameEvent {
  final double volume;

  const MatchGameBgmVolumeChanged({
    required this.volume,
  });
}

class MatchGameSfxVolumeChanged extends MatchGameEvent {
  final double volume;

  const MatchGameSfxVolumeChanged({
    required this.volume,
  });
}

class MatchGameSfxButtonPressed extends MatchGameEvent {
  const MatchGameSfxButtonPressed();
}

class MatchGameTutorialStarted extends MatchGameEvent {
  const MatchGameTutorialStarted();
}

class MatchGameTutorialNextPressed extends MatchGameEvent {
  const MatchGameTutorialNextPressed();
}

class MatchGameTutorialFinished extends MatchGameEvent {
  const MatchGameTutorialFinished();
}
