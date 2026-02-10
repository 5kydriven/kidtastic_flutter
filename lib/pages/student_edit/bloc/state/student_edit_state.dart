import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../models/models.dart';

part 'student_edit_state.freezed.dart';

@freezed
sealed class StudentEditState with _$StudentEditState {
  const factory StudentEditState({
    Student? student,
    @Default(RequestStatus.waiting) RequestStatus studentRequestStatus,
    @Default(TextFieldInput(value: '')) TextFieldInput firstName,
    @Default(TextFieldInput(value: '')) TextFieldInput lastName,
    @Default(TextFieldInput(value: '')) TextFieldInput gender,
    @Default(Assets.sheepAvatar) String selectedAvatar,
    @Default(false) bool isAvatarMenuOpen,
  }) = _StudentEditState;
}
