import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'counting_game_state.freezed.dart';

enum CountingGameTutorialStep {
  none,
  welcome,
  question,
  contents,
  buttons,
  finished,
}

@freezed
sealed class CountingGameState with _$CountingGameState {
  const factory CountingGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    DateTime? sessionStartTime,
    @Default(0) int score,
    @Default(false) hasEnded,
    @Default([]) List<Offset> imagePositions,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
    @Default(CountingGameTutorialStep.none)
    CountingGameTutorialStep tutorialStep,
  }) = _CountingGameState;
}
