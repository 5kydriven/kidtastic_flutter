import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'tracing_game_state.freezed.dart';

@freezed
sealed class TracingGameState with _$TracingGameState {
  const factory TracingGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    DateTime? sessionStartTime,
    @Default(0) int score,
    @Default(false) hasEnded,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
  }) = _TracingGameState;
}
