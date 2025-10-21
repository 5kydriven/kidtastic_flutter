import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kidtastic_flutter/models/models.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    Student? student,
    @Default(0) int currentPage,
    @Default([]) List<Game> games,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
  }) = _HomeState;
}
