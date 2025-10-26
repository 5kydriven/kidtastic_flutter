import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/models.dart';

part 'speech_recognition_state.freezed.dart';

@freezed
sealed class SpeechRecognitionState with _$SpeechRecognitionState {
  const factory SpeechRecognitionState({
    @Default(RequestStatus.waiting) RequestStatus status,
    @Default(false) bool isRecording,
    @Default(0) int currentIndex,
    @Default([]) List<String> words,
    String? currentWord,
    String? recognizedText,
    @Default(false) bool isCorrect,
    @Default(0) double confidenceScore,
  }) = _SpeechRecognitionState;
}
