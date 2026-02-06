import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'bubble_game_state.freezed.dart';

@freezed
sealed class BubbleGameState with _$BubbleGameState {
  const factory BubbleGameState({
    @Default(RequestStatus.waiting) RequestStatus screanRequestStatus,
  }) = _BubbleGameState;
}
