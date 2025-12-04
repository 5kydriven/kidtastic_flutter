import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'match_game_state.freezed.dart';

@freezed
sealed class MatchGameState with _$MatchGameState {
  const factory MatchGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    @Default(0) int score,
    @Default(false) bool hasEnded,
    Question? droppedItem,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
  }) = _MatchGameState;
}
