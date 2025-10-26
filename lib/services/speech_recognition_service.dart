import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:kidtastic_flutter/utils/model_config.dart';
import 'package:record/record.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import '../utils/utils.dart';
import 'services.dart';

class SpeechRecognitionService {
  static SpeechRecognitionService? _instance;
  static SpeechRecognitionService get instance {
    _instance ??= SpeechRecognitionService._();
    return _instance!;
  }

  SpeechRecognitionService._();

  late final AudioRecorder _audioRecorder;
  sherpa_onnx.OnlineRecognizer? _recognizer;
  sherpa_onnx.OnlineStream? _stream;

  bool _isInitialized = false;
  bool _isRecording = false;
  final int _sampleRate = 16000;
  String _lastRecognizedText = '';

  StreamSubscription<RecordState>? _recordSub;

  final StreamController<String> _textController =
      StreamController<String>.broadcast();
  final StreamController<bool> _recordingStateController =
      StreamController<bool>.broadcast();

  // ✅ Added: Silence detection stream
  final StreamController<bool> _silenceController =
      StreamController<bool>.broadcast();
  Stream<bool> get silenceStream => _silenceController.stream;

  Timer? _silenceTimer;
  bool _isSilent = false;

  Stream<String> get textStream => _textController.stream;
  Stream<bool> get recordingStateStream => _recordingStateController.stream;
  bool get isRecording => _isRecording;
  String get lastRecognizedText => _lastRecognizedText;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _audioRecorder = AudioRecorder();
      _recordSub = _audioRecorder.onStateChanged().listen((recordState) {});
      sherpa_onnx.initBindings();
      _recognizer = await _createOnlineRecognizer();
      _stream = _recognizer?.createStream();
      await MicrophonePermissionService.instance.initialize();
      _isInitialized = true;
      _isRecording = false;
    } catch (e) {
      debugPrint('Error initializing SpeechRecognitionService: $e');
      rethrow;
    }
  }

  Future<sherpa_onnx.OnlineRecognizer> _createOnlineRecognizer() async {
    final type = 0;
    final modelConfig = await getModelConfig(type: type);
    final config = sherpa_onnx.OnlineRecognizerConfig(
      model: modelConfig,
      ruleFsts: '',
    );
    return sherpa_onnx.OnlineRecognizer(config);
  }

  Future<bool> startRecording() async {
    if (!_isInitialized) await initialize();
    if (_isRecording) return false;

    try {
      final hasPermission = await MicrophonePermissionService.instance
          .checkMicrophonePermission();
      if (!hasPermission) return false;

      const encoder = AudioEncoder.pcm16bits;
      if (!await _isEncoderSupported(encoder)) return false;

      const config = RecordConfig(
        encoder: encoder,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 128000,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
      );

      final stream = await _audioRecorder.startStream(config);
      _isRecording = true;
      _recordingStateController.add(true);

      stream.listen(
        (data) {
          if (data.isNotEmpty) _processAudioData(Uint8List.fromList(data));
        },
        onDone: () => debugPrint('Audio stream stopped'),
        onError: (error) => debugPrint('Audio stream error: $error'),
      );
      return true;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _isRecording = false;
      _recordingStateController.add(false);
      return false;
    }
  }

  void _processAudioData(Uint8List data) {
    if (!_isInitialized || _stream == null || _recognizer == null) return;

    try {
      final samplesFloat32 = convertBytesToFloat32(data);
      _stream!.acceptWaveform(samples: samplesFloat32, sampleRate: _sampleRate);

      while (_recognizer!.isReady(_stream!)) {
        _recognizer!.decode(_stream!);
      }

      final result = _recognizer!.getResult(_stream!);
      final rawText = result.text;
      final text = _normalizeRecognizedText(rawText);

      String textToDisplay = _lastRecognizedText;
      if (text.isNotEmpty) {
        textToDisplay = _lastRecognizedText.isEmpty
            ? text
            : '$_lastRecognizedText\n$text';
      }

      if (_recognizer!.isEndpoint(_stream!)) {
        _recognizer!.reset(_stream!);
        if (text.isNotEmpty) _lastRecognizedText = textToDisplay;
      }

      if (textToDisplay != _lastRecognizedText ||
          _recognizer!.isEndpoint(_stream!)) {
        _textController.add(textToDisplay);

        // ✅ Reset silence detection when new speech recognized
        _resetSilenceTimer();
      }
    } catch (e) {
      debugPrint('Error processing audio data: $e');
    }
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _isSilent = false;
    final randomDuration = Duration(
      milliseconds: 1500 + Random().nextInt(500),
    );
    _silenceTimer = Timer(randomDuration, () {
      if (_isRecording && !_isSilent) {
        _isSilent = true;
        _silenceController.add(true);
      }
    });
  }

  String _normalizeRecognizedText(String text) {
    var t = text;
    t = t.replaceAll('▁', ' ');
    t = t.replaceFirst(RegExp(r'^\s*-+\s*'), '');
    t = t.replaceAll(RegExp(r'\s*-\s+'), ' ');
    t = t.replaceAll(RegExp(r'\s{2,}'), ' ');
    return t.trim();
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      _recordingStateController.add(false);
      _silenceTimer?.cancel();
      if (_stream != null && _recognizer != null) {
        _stream!.free();
        _stream = _recognizer!.createStream();
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  void clearText() {
    _lastRecognizedText = '';
    _textController.add('');
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(encoder);
    if (!isSupported) {
      debugPrint('${encoder.name} not supported.');
      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${e.name}');
        }
      }
    }
    return isSupported;
  }

  void dispose() {
    _recordSub?.cancel();
    _audioRecorder.dispose();
    _stream?.free();
    _recognizer?.free();
    _textController.close();
    _recordingStateController.close();
    _silenceController.close();
    _silenceTimer?.cancel();
    _isInitialized = false;
  }
}
