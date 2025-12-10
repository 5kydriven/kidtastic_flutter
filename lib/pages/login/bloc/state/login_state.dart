import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _LoginState;
}
