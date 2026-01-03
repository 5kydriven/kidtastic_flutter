import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _DashboardState;
}
