import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'bubble_game_state.freezed.dart';

@freezed
sealed class BubbleGameState with _$BubbleGameState {
  const factory BubbleGameState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    Game? game,
    Student? student,
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
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
  }) = _BubbleGameState;
}
