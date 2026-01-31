import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'student_profile_state.freezed.dart';

@freezed
sealed class StudentProfileState with _$StudentProfileState {
  const factory StudentProfileState({
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
    Student? student,
  }) = _StudentProfileState;
}
