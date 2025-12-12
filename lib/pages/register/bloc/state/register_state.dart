import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'register_state.freezed.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState({
    Teacher? teacher,
    @Default(TextFieldInput(value: '')) TextFieldInput name,
    @Default(TextFieldInput(value: '')) TextFieldInput email,
    @Default(TextFieldInput(value: '')) TextFieldInput password,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _RegisterState;
}
