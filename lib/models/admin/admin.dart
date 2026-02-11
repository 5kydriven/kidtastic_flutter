import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

@freezed
sealed class Admin with _$Admin {
  const factory Admin({
    int? id,
    String? name,
    String? username,
    String? password,
    String? avatar,
    bool? isSynced,
    int? createdAt,
  }) = _Admin;

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);
}
