import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'initial_screen_state.freezed.dart';

@freezed
sealed class InitialScreenState with _$InitialScreenState {
  const factory InitialScreenState({
    @Default([]) List<Student> students,
    @Default(0) int currentPage,
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
    @Default(RequestStatus.waiting) RequestStatus studentRequestStatus,
    @Default(
      TextFieldInput(
        value: '',
      ),
    )
    TextFieldInput? name,
  }) = _InitialScreenState;
}
