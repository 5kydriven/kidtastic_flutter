import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kidtastic_flutter/models/models.dart';

part 'analytics_state.freezed.dart';

@freezed
sealed class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _AnalyticsState;
}
