import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kidtastic_flutter/models/models.dart';

part 'game_list_state.freezed.dart';

enum GameListTutorialStep {
  none,
  welcome,
  games,
  finished,
}

@freezed
sealed class GameListState with _$GameListState {
  const factory GameListState({
    Student? student,
    @Default(0) int currentPage,
    @Default([]) List<Game> games,
    @Default(0.0) double bgmVolume,
    @Default(0.0) double sfxVolume,
    @Default(false) bool isBgmMuted,
    @Default(false) bool isSfxMuted,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(GameListTutorialStep.none) GameListTutorialStep tutorialStep,
  }) = _GameListState;
}
