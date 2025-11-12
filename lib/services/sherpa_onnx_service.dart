import 'dart:typed_data';

import 'package:kidtastic_flutter/utils/model_config.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;

import '../utils/utils.dart';

class SherpaOnnxService {
  late final sherpa_onnx.OnlineRecognizer _recognizer;
  late sherpa_onnx.OnlineStream _stream;
  var _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    sherpa_onnx.initBindings();
    final modelConfig = await getOnlineModelConfig(
      type: 0,
    );

    final config = sherpa_onnx.OnlineRecognizerConfig(
      model: modelConfig,
      ruleFsts: '',
    );

    _recognizer = sherpa_onnx.OnlineRecognizer(config);
    _stream = _recognizer.createStream();
    _isInitialized = true;
  }

  void acceptAudio(Uint8List data) {
    if (!_isInitialized) return;

    final samplesFloat32 = convertBytesToFloat32(data);
    _stream.acceptWaveform(
      samples: samplesFloat32,
      sampleRate: 16000,
    );

    while (_recognizer.isReady(_stream)) {
      _recognizer.decode(_stream);
    }
  }

  String getText() {
    if (!_isInitialized) return '';
    return _recognizer.getResult(_stream).text;
  }

  bool isEndpoint() {
    if (!_isInitialized) return false;
    return _recognizer.isEndpoint(_stream);
  }

  void reset() {
    if (!_isInitialized) return;
    _recognizer.reset(_stream);
  }

  void dispose() {
    _stream.free();
    _recognizer.free();
    _isInitialized = false;
  }
}
