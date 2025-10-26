import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import 'bloc.dart';
import 'dart:math'; // 👈 Needed for min/max

class SpeechRecognitionBloc
    extends Bloc<SpeechRecognitionEvent, SpeechRecognitionState> {
  final SpeechRecognitionService _speechService;

  StreamSubscription<String>? _textSub;
  StreamSubscription<bool>? _recSub;

  SpeechRecognitionBloc({
    required SpeechRecognitionService speechService,
  }) : _speechService = speechService,
       super(const SpeechRecognitionState()) {
    on<SpeechRecognitionGameStarted>(_onGameStarted);
    on<SpeechRecognitionTextRecognized>(_onTextRecognized);
    on<SpeechRecognitionToggleRecording>(_onToggleRecording);
    on<SpeechRecognitionClearText>(_onClearText);
    on<SpeechRecognitionNextWord>(_onNextWord);
  }

  Future<void> _onGameStarted(
    SpeechRecognitionGameStarted event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    await _speechService.initialize();

    const words = [
      'apple',
      'banana',
      'I am playing',
      'orange',
      'good morning',
    ];

    _textSub = _speechService.textStream.listen((t) {
      print('here: $t');
      add(SpeechRecognitionTextRecognized(t));
    });

    emit(
      state.copyWith(
        status: RequestStatus.success,
        words: words,
        currentWord: words.first,
        currentIndex: 0,
        recognizedText: '',
        isCorrect: false,
        confidenceScore: 0,
      ),
    );
  }

  void _onTextRecognized(
    SpeechRecognitionTextRecognized event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    final currentWord = state.currentWord?.toLowerCase().trim() ?? '';
    final recognized = event.recognizedText.toLowerCase().trim();

    final similarity = _calculateSimilarity(currentWord, recognized);
    final isCorrect = similarity >= 0.8; // 👈 80% threshold for "correct"
    final confidence = (similarity * 100).clamp(0, 100);

    emit(
      state.copyWith(
        recognizedText: event.recognizedText,
        isCorrect: isCorrect,
        confidenceScore: double.parse(confidence.toStringAsFixed(2)),
      ),
    );
  }

  Future<void> _onToggleRecording(
    SpeechRecognitionToggleRecording event,
    Emitter<SpeechRecognitionState> emit,
  ) async {
    if (_speechService.isRecording) {
      await _speechService.stopRecording();
      emit(state.copyWith(isRecording: false));
    } else {
      await _speechService.startRecording();
      emit(state.copyWith(isRecording: true));
    }
  }

  void _onClearText(
    SpeechRecognitionClearText event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    _speechService.clearText();
    emit(
      state.copyWith(recognizedText: '', isCorrect: false, confidenceScore: 0),
    );
  }

  void _onNextWord(
    SpeechRecognitionNextWord event,
    Emitter<SpeechRecognitionState> emit,
  ) {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex < state.words.length) {
      emit(
        state.copyWith(
          currentIndex: nextIndex,
          currentWord: state.words[nextIndex],
          recognizedText: '',
          isCorrect: false,
          confidenceScore: 0,
        ),
      );
    } else {
      emit(state.copyWith(status: RequestStatus.success));
    }
  }

  @override
  Future<void> close() async {
    await _textSub?.cancel();
    await _recSub?.cancel();
    _speechService.dispose();
    return super.close();
  }

  // 👇 Levenshtein-based similarity function (0.0 – 1.0)
  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final m = List.generate(
      s1.length + 1,
      (i) => List<int>.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          m[i][j] = j;
        } else if (j == 0) {
          m[i][j] = i;
        } else {
          m[i][j] = min(
            min(m[i - 1][j] + 1, m[i][j - 1] + 1),
            m[i - 1][j - 1] + (s1[i - 1] == s2[j - 1] ? 0 : 1),
          );
        }
      }
    }

    final distance = m[s1.length][s2.length];
    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (distance / maxLen);
  }
}
