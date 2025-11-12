import 'package:freezed_annotation/freezed_annotation.dart';

part 'pronunciation_attempt.g.dart';
part 'pronunciation_attempt.freezed.dart';

@freezed
sealed class PronunciationAttempt with _$PronunciationAttempt {
  const factory PronunciationAttempt({
    int? id,
    int? sessionQuestionId,
    String? word,
    String? recognizedText,
    double? confidence,
    bool? isCorrect,
    String? audioPath,
  }) = _PronunciationAttempt;

  factory PronunciationAttempt.fromJson(Map<String, dynamic> json) =>
      _$PronunciationAttemptFromJson(json);
}
