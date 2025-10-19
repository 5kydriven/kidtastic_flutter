import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
sealed class Game with _$Game {
  const factory Game({
    int? id,
    String? name,
    String? description,
    String? category,
    bool? isSynced,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
