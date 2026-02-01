import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
sealed class Student with _$Student {
  const factory Student({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    bool? isSynced,
    DateTime? lastPlayedAt,
    int? createdAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
