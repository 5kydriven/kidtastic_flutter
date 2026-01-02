import 'package:kidtastic_flutter/extensions/extentions.dart';

import '../models/models.dart';

ErrorType validateRequired(String value) {
  return value.trim().isEmpty ? ErrorType.empty : ErrorType.none;
}

ErrorType validateMinLength(String value, int min) {
  return value.length < min ? ErrorType.length : ErrorType.none;
}

ErrorType validateMaxLength(String value, int max) {
  return value.length > max ? ErrorType.length : ErrorType.none;
}

ErrorType validateExactLength(String value, int length) {
  return value.length != length ? ErrorType.length : ErrorType.none;
}

ErrorType validateEmail(String value) {
  return value.isValidEmail() ? ErrorType.none : ErrorType.format;
}
