import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session.freezed.dart';
part 'game_session.g.dart';

@freezed
sealed class GameSession with _$GameSession {
  const factory GameSession({
    int? id,
    int? studentId,
    int? gameId,
    int? score,
    DateTime? startedAt,
    DateTime? endedAt,
  }) = _GameSession;

  factory GameSession.fromJson(Map<String, dynamic> json) =>
      _$GameSessionFromJson(json);
}
