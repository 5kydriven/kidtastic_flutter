import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_field_input.freezed.dart';

enum ErrorType {
  empty,
  length,
  value,
  format,
  none,
}

@freezed
sealed class TextFieldInput with _$TextFieldInput {
  const factory TextFieldInput({
    @Default('') String value,
    @Default(ErrorType.none) ErrorType errorType,
    @Default(null) String? error,
    @Default(false) bool obscureText,
  }) = _TextFieldInput;
}
