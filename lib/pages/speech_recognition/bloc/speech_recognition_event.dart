sealed class SpeechRecognitionEvent {
  const SpeechRecognitionEvent();
}

class SpeechRecognitionGameStarted extends SpeechRecognitionEvent {
  const SpeechRecognitionGameStarted();
}

class SpeechRecognitionTextRecognized extends SpeechRecognitionEvent {
  final String recognizedText;
  const SpeechRecognitionTextRecognized(this.recognizedText);
}

class SpeechRecognitionToggleRecording extends SpeechRecognitionEvent {
  const SpeechRecognitionToggleRecording();
}

class SpeechRecognitionClearText extends SpeechRecognitionEvent {
  const SpeechRecognitionClearText();
}

class SpeechRecognitionNextWord extends SpeechRecognitionEvent {
  const SpeechRecognitionNextWord();
}
