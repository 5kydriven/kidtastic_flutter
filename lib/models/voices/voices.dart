import 'package:freezed_annotation/freezed_annotation.dart';

part 'voices.freezed.dart';
part 'voices.g.dart';

@freezed
sealed class Voices with _$Voices {
  const factory Voices({
    String? gender,
    String? identifier,
    String? locale,
    String? name,
  }) = _Voices;

  factory Voices.fromJson(Map<String, dynamic> json) => _$VoicesFromJson(json);
}
