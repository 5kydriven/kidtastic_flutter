import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_session.freezed.dart';

@freezed
sealed class RecentSession with _$RecentSession {
  const factory RecentSession({
    required String studentId,
    required String studentName,
    required String? studentImage,
    required String gameId,
    required String gameName,
    required int score,
    required int totalQuestions,
    required DateTime playedAt,
  }) = _RecentSession;
}
