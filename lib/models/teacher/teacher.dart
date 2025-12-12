import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher.freezed.dart';
part 'teacher.g.dart';

@freezed
sealed class Teacher with _$Teacher {
  const factory Teacher({
    int? id,
    String? name,
    String? username,
    String? password,
    String? avatar,
    bool? isSynced,
  }) = _Teacher;

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
}
