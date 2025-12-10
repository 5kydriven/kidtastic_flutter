import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'register_state.freezed.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _RegisterState;
}
