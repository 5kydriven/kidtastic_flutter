import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'counting_game_state.freezed.dart';

@freezed
sealed class CountingGameState with _$CountingGameState {
  const factory CountingGameState({
    Student? student,
    Game? game,
    @Default([]) List<Question> question,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _CountingGameState;
}
