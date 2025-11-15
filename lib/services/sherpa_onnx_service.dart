import 'dart:async';
import 'dart:typed_data';
import 'package:kidtastic_flutter/utils/model_config.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import '../utils/utils.dart';

class SpeechRecognitionService {
  // Nullable fields
  sherpa_onnx.OnlineRecognizer? _recognizer;
  sherpa_onnx.OnlineStream? _stream;
  bool _isInitialized = false;

  final _textController = StreamController<String>.broadcast();
  final _silenceController = StreamController<bool>.broadcast();

  Stream<String> get textStream => _textController.stream;
  Stream<bool> get silenceStream => _silenceController.stream;

  bool get isRecording => _stream != null;

  /// Initialize safely
  Future<void> initialize() async {
    if (_isInitialized) return;

    sherpa_onnx.initBindings();
    final modelConfig = await getOnlineModelConfig(type: 0);

    final config = sherpa_onnx.OnlineRecognizerConfig(
      model: modelConfig,
      ruleFsts: '',
    );

    _recognizer ??= sherpa_onnx.OnlineRecognizer(config);
    _stream ??= _recognizer!.createStream();
    _isInitialized = true;
  }

  /// Start recording safely
  Future<void> startRecording() async {
    if (!_isInitialized) await initialize();
    _stream ??= _recognizer!.createStream();
  }

  /// Stop recording safely
  Future<void> stopRecording() async {
    if (_stream != null) {
      _stream!.free();
      _stream = null;
    }
  }

  /// Accept audio
  void acceptAudio(Uint8List data) {
    if (_stream == null) return;

    final samplesFloat32 = convertBytesToFloat32(data);
    _stream!.acceptWaveform(samples: samplesFloat32, sampleRate: 16000);

    while (_recognizer!.isReady(_stream!)) {
      _recognizer!.decode(_stream!);
    }
  }

  /// Get recognized text
  String getText() =>
      _stream != null ? _recognizer!.getResult(_stream!).text : '';

  bool isEndpoint() => _stream != null && _recognizer!.isEndpoint(_stream!);

  /// Clear text safely
  void clearText() {
    if (!_textController.isClosed) {
      _textController.add('');
    }
  }

  /// Dispose safely
  void dispose() {
    _stream?.free();
    _stream = null;

    _recognizer?.free();
    _recognizer = null;

    _isInitialized = false;

    if (!_textController.isClosed) _textController.close();
    if (!_silenceController.isClosed) _silenceController.close();
  }
}
