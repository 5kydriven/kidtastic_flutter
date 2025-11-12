import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:kidtastic_flutter/utils/utils.dart';

Future<Map<String, dynamic>> loadSherpaModel(_) async {
  final modelDir = 'assets/models/sherpa-onnx-streaming-zipformer-en-kroko';

  final encoder = await copyAssetFile('$modelDir/encoder.onnx');
  final decoder = await copyAssetFile('$modelDir/decoder.onnx');
  final joiner = await copyAssetFile('$modelDir/joiner.onnx');
  final tokens = await copyAssetFile('$modelDir/tokens.txt');

  final config = OnlineRecognizerConfig(
    model: OnlineModelConfig(
      transducer: OnlineTransducerModelConfig(
        encoder: encoder,
        decoder: decoder,
        joiner: joiner,
      ),
      tokens: tokens,
      modelType: 'zipformer2',
    ),
    ruleFsts: '',
  );

  // Return only lightweight data — not native objects
  return {'config': config};
}
