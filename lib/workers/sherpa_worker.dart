// sherpa_worker.dart
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

/// Worker entrypoint. Receives a SendPort as the first message (init).
void sherpaWorker(SendPort initSendPort) async {
  final port = ReceivePort();
  initSendPort.send(port.sendPort);

  // initialize native bindings (required by sherpa_onnx)
  sherpa.initBindings();

  sherpa.OnlineRecognizer? recognizer;
  sherpa.OnlineStream? stream;
  SendPort? replyPort;

  // Simple RMS-based silence detector state
  const double silenceThreshold = 0.0015;
  // Increased from 30 to 100 for longer silence detection (~10 seconds)
  // Adjust based on your audio chunk frequency:
  // - If chunks are 100ms apart: 100 frames = 10 seconds
  // - If chunks are 200ms apart: 100 frames = 20 seconds
  int quietFramesForSilence = 30;
  int consecutiveQuietFrames = 0;

  await for (final rawMsg in port) {
    if (rawMsg is! Map) continue;
    final type = rawMsg['type'] as String? ?? '';

    switch (type) {
      case 'init':
        {
          replyPort = rawMsg['replyPort'] as SendPort?;
          final config = rawMsg['config'] as sherpa.OnlineRecognizerConfig?;
          // Allow configuring silence duration from init
          if (rawMsg.containsKey('quietFramesForSilence')) {
            quietFramesForSilence = rawMsg['quietFramesForSilence'] as int;
          }
          if (config == null || replyPort == null) {
            // invalid init, ignore
            break;
          }
          recognizer = sherpa.OnlineRecognizer(config);
          stream = recognizer.createStream();

          replyPort.send({'type': 'ready'});
        }
        break;

      case 'audio':
        {
          // receive audio chunk as Float32List
          final samples = rawMsg['samples'] as Float32List?;
          final sampleRate = rawMsg['sampleRate'] as int? ?? 16000;
          if (samples == null ||
              recognizer == null ||
              stream == null ||
              replyPort == null) {
            break;
          }

          // feed waveform into model
          stream.acceptWaveform(samples: samples, sampleRate: sampleRate);

          // decode while available
          while (recognizer.isReady(stream)) {
            recognizer.decode(stream);
          }

          // compute result and send back
          final result = recognizer.getResult(stream);
          final text = result.text;
          replyPort.send({
            'type': 'result',
            'text': text,
          });

          // --- simple silence detection (RMS)
          double sumSquares = 0.0;
          for (int i = 0; i < samples.length; i++) {
            final v = samples[i];
            sumSquares += v * v;
          }
          final rms = samples.isNotEmpty
              ? math.sqrt(sumSquares / samples.length)
              : 0.0;

          if (rms < silenceThreshold) {
            consecutiveQuietFrames++;
          } else {
            consecutiveQuietFrames = 0;
          }

          if (consecutiveQuietFrames >= quietFramesForSilence) {
            // notify caller that there's sustained silence
            print('Detected sustained silence');
            replyPort.send({'type': 'silence'});
            consecutiveQuietFrames = 0;
          }
        }
        break;

      case 'reset':
        {
          // free existing stream & recreate so subsequent results don't accumulate
          try {
            stream?.free();
          } catch (_) {}
          if (recognizer != null) {
            stream = recognizer.createStream();
          }
          consecutiveQuietFrames = 0;
        }
        break;

      case 'dispose':
        {
          try {
            stream?.free();
          } catch (_) {}
          try {
            recognizer?.free();
          } catch (_) {}
          Isolate.exit();
        }

      default:
        break;
    }
  }
}
