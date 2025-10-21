import 'package:freezed_annotation/freezed_annotation.dart';

part 'fruit.freezed.dart';
part 'fruit.g.dart';

@freezed
sealed class Fruit with _$Fruit {
  const factory Fruit({
    String? name,
    String? image,
  }) = _Fruit;

  factory Fruit.fromJson(Map<String, dynamic> json) => _$FruitFromJson(json);
}
