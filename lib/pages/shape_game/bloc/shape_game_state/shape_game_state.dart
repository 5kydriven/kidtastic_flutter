import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'shape_game_state.freezed.dart';

@freezed
sealed class ShapeGameState with _$ShapeGameState {
  const factory ShapeGameState({
    Game? game,
    Student? student,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _ShapegameState;
}
