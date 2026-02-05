import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_ranking.freezed.dart';

@freezed
sealed class StudentRanking with _$StudentRanking {
  const factory StudentRanking({
    required String studentId,
    required String studentName,
    required String? studentImage,
    required double averageAccuracy,
    required int totalSessions,
    required int rank,
  }) = _StudentRanking;
}
