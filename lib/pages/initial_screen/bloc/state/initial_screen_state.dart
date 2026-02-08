import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'initial_screen_state.freezed.dart';

@freezed
sealed class InitialScreenState with _$InitialScreenState {
  const factory InitialScreenState({
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _InitialScreenState;
}
