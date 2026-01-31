import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'activities_state.freezed.dart';

@freezed
sealed class ActivitiesState with _$ActivitiesState {
  const factory ActivitiesState({
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
  }) = _ActivitiesState;
}
