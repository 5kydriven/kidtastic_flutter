import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'color_game_state.freezed.dart';

@freezed
sealed class ColorGameState with _$ColorGameState {
  const factory ColorGameState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _ColorGameState;
}
