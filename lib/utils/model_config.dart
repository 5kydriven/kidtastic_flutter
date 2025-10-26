import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'utils.dart';

Future<OnlineModelConfig> getModelConfig({
  required int type,
}) async {
  switch (type) {
    case 0:
      final modelDir = 'assets/models/sherpa-onnx-streaming-zipformer-en-kroko';
      return OnlineModelConfig(
        transducer: OnlineTransducerModelConfig(
          encoder: await copyAssetFile('$modelDir/encoder.onnx'),
          decoder: await copyAssetFile('$modelDir/decoder.onnx'),
          joiner: await copyAssetFile('$modelDir/joiner.onnx'),
        ),
        tokens: await copyAssetFile('$modelDir/tokens.txt'),
        modelType: 'zipformer2',
      );
    default:
      throw ArgumentError('Unsupported type: $type');
  }
}
