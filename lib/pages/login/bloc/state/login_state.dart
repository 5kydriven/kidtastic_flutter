import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default(TextFieldInput(value: '')) TextFieldInput username,
    @Default(TextFieldInput(value: '')) TextFieldInput password,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus loginRequestStatus,
  }) = _LoginState;
}
