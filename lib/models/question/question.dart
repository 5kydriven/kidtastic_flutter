import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

enum Difficulty {
  easy,
  medium,
  hard,
  veryHard,
}

@freezed
sealed class Question with _$Question {
  const factory Question({
    int? id,
    int? gameId,
    String? question,
    Difficulty? difficulty,
    String? correctAnswer,
    String? image,
    String? audio,
    String? choices,
    bool? isSynced,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}
