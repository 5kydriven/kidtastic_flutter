import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'pronunciation_game_state.freezed.dart';

@freezed
sealed class PronunciationGameState with _$PronunciationGameState {
  const factory PronunciationGameState({
    Game? game,
    Student? student,
    @Default([]) List<Question> question,
    @Default(0) int currentIndex,
    int? sessionId,
    @Default(0) int score,
    @Default('') String recognizedText,
    @Default(false) bool isCorrect,
    @Default(0) currentSessionQuestionId,
    @Default(0) double confidenceScore,
    @Default(false) bool isRecording,
    @Default(Duration(seconds: 2)) Duration silenceTimeout,
    @Default(Duration(seconds: 8)) Duration maxRecordingTime,
    @Default(0) int attempts,
    @Default(false) bool isModelReady,
    @Default(RequestStatus.waiting) RequestStatus sessionQuestionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus sessionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus gameSessionRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus screenRequestStatus,
    @Default(RequestStatus.waiting) RequestStatus pronunciationRequestStatus,
  }) = _PronunciationGameState;
}
