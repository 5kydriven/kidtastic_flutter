import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'forgot_password_state.freezed.dart';

@freezed
sealed class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(RequestStatus.waiting) RequestStatus nextRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus teacherRequestStatus,
    @Default(1) int currentStep,
    @Default(TextFieldInput(value: '', obscureText: true))
    TextFieldInput password,
    @Default(TextFieldInput(value: '', obscureText: true))
    TextFieldInput confirmPassword,
    @Default(TextFieldInput(value: '')) TextFieldInput username,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    Admin? admin,
  }) = _ForgotPasswordState;
}
