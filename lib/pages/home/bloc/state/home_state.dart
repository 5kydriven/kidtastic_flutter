import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kidtastic_flutter/models/models.dart';

part 'home_state.freezed.dart';

enum HomeTutorialStep {
  none,
  welcome,
  games,
  finished,
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    Student? student,
    @Default(0) int currentPage,
    @Default([]) List<Game> games,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(HomeTutorialStep.none) HomeTutorialStep tutorialStep,
  }) = _HomeState;
}
