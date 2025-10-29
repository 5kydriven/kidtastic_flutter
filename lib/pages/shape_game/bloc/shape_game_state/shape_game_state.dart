import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'shape_game_state.freezed.dart';

@freezed
sealed class ShapeGameState with _$ShapeGameState {
  const factory ShapeGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    @Default(0) int score,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
  }) = _ShapegameState;
}
