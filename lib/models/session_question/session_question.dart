import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_question.freezed.dart';
part 'session_question.g.dart';

@freezed
sealed class SessionQuestion with _$SessionQuestion {
  const factory SessionQuestion({
    int? id,
    int? sessionId,
    int? questionId,
    String? studentAnswer,
    bool? isCorrect,
  }) = _SessionQuestion;

  factory SessionQuestion.fromJson(Map<String, dynamic> json) =>
      _$SessionQuestionFromJson(json);
}
