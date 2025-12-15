import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _DashboardState;
}
