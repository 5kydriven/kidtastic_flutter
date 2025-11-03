import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'counting_game_state.freezed.dart';

@freezed
sealed class CountingGameState with _$CountingGameState {
  const factory CountingGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    @Default(0) int score,
    @Default(false) hasEnded,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
  }) = _CountingGameState;
}
