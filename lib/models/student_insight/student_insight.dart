import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_insight.freezed.dart';
part 'student_insight.g.dart';

@freezed
sealed class StudentInsight with _$StudentInsight {
  const factory StudentInsight({
    int? studentId,
    int? gameId,
    double? averageScore,
    int? totalSessions,
    DateTime? lastPlayed,
    String? strength,
    String? weakness,
  }) = _StudentInsight;

  factory StudentInsight.fromJson(Map<String, dynamic> json) =>
      _$StudentInsightFromJson(json);
}
