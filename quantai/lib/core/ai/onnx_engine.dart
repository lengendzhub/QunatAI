// lib/core/ai/onnx_engine.dart
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:onnxruntime/onnxruntime.dart';

import 'model_config.dart';

class OnnxEngine {
  final Logger _logger = Logger('OnnxEngine');
  OrtSession? _session;

  bool get isLoaded => _session != null;

  Future<void> load() async {
    final bytes = await rootBundle.load(ModelConfig.assetPath);
    final data = bytes.buffer.asUint8List();

    final options = OrtSessionOptions();
    _session = OrtSession.fromBuffer(data, options);
    _logger.info('ONNX model loaded (${data.length} bytes)');
  }

  ({double longProb, double shortProb})? predict(List<List<double>> featureMatrix) {
    final session = _session;
    if (session == null) {
      return null;
    }

    if (featureMatrix.length != ModelConfig.lookback) {
      throw ArgumentError('Expected lookback=${ModelConfig.lookback}, got ${featureMatrix.length}');
    }

    final expectedFeatures = ModelConfig.numFeatures;
    for (final row in featureMatrix) {
      if (row.length != expectedFeatures) {
        throw ArgumentError('Expected $expectedFeatures features per row, got ${row.length}');
      }
    }

    final flat = Float32List(ModelConfig.lookback * ModelConfig.numFeatures);
    var idx = 0;
    for (final row in featureMatrix) {
      for (final v in row) {
        flat[idx++] = v;
      }
    }

    final inputTensor = OrtValueTensor.createTensorWithDataList(
      flat,
      <int>[1, ModelConfig.lookback, ModelConfig.numFeatures],
    );

    final runOptions = OrtRunOptions();
    final outputs = session.run(runOptions, <String, OrtValue>{'input': inputTensor});

    final first = outputs.first;
    if (first == null) {
      inputTensor.release();
      runOptions.release();
      return null;
    }

    final values = (first.value as List<List<double>>).first;

    inputTensor.release();
    runOptions.release();

    return (
      longProb: values[ModelConfig.outputLongIndex],
      shortProb: values[ModelConfig.outputShortIndex],
    );
  }

  void dispose() {
    _session?.release();
    _session = null;
  }
}
