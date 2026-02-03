import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'match_game_state.freezed.dart';

enum MatchGameTutorialStep {
  none,
  welcome,
  question,
  contents,
  buttons,
  finished,
}

@freezed
sealed class MatchGameState with _$MatchGameState {
  const factory MatchGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    DateTime? sessionStartTime,
    @Default(0) int score,
    @Default(false) bool hasEnded,
    Question? droppedItem,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
    @Default(MatchGameTutorialStep.none) MatchGameTutorialStep tutorialStep,
  }) = _MatchGameState;
}
