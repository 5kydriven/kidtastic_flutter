import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/constants.dart';
import '../../../../models/models.dart';

part 'initial_screen_state.freezed.dart';

@freezed
sealed class InitialScreenState with _$InitialScreenState {
  const factory InitialScreenState({
    @Default([]) List<Student> students,
    @Default(0) int currentPage,
    @Default(Assets.sheepAvatar) String selectedAvatar,
    @Default(false) bool isAvatarMenuOpen,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus requestStatus,
    @Default(RequestStatus.waiting) RequestStatus studentRequestStatus,
    @Default(TextFieldInput(value: '')) TextFieldInput firstName,
    @Default(TextFieldInput(value: '')) TextFieldInput lastName,
    @Default(TextFieldInput(value: '')) TextFieldInput gender,
  }) = _InitialScreenState;
}
