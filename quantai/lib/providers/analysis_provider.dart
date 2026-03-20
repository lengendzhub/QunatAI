// lib/providers/analysis_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/ai/feature_builder.dart';
import '../core/ai/model_config.dart';
import '../core/analysis/ict_engine.dart';
import '../models/analysis_result.dart';
import '../models/market_regime.dart';
import '../models/proposal.dart';
import 'broker_provider.dart';
import 'candles_provider.dart';

final analysisProvider = StreamProvider.family<AnalysisResult?, String>((ref, symbol) async* {
  final broker = ref.watch(brokerProvider);
  final engine = ref.watch(onnxEngineProvider);
  final ict = IctEngine();
  final fb = FeatureBuilder();

  await for (final _ in broker.candleStream(symbol: symbol, granularity: '5M')) {
    final c4h = await ref.read(candlesProvider((symbol: symbol, timeframe: '4H')).future);
    final c1h = await ref.read(candlesProvider((symbol: symbol, timeframe: '1H')).future);
    final c5m = await ref.read(candlesProvider((symbol: symbol, timeframe: '5M')).future);

    if (c5m.length < ModelConfig.lookback) {
      continue;
    }

    final features = ict.analyse(candles4h: c4h, candles1h: c1h, candles5m: c5m);
    if (features.regime == MarketRegime.lowVolatility) {
      continue;
    }

    final matrix = fb.build(c5m, features);
    final probs = engine.predict(matrix);
    if (probs == null) {
      continue;
    }

    final gate = features.regime == MarketRegime.volatile ? ModelConfig.volatileGate : ModelConfig.confidenceGate;
    final longSignal = probs.longProb >= gate;
    final shortSignal = probs.shortProb >= gate;
    if (!longSignal && !shortSignal) {
      continue;
    }

    if (!features.mtfAligned) {
      continue;
    }

    final last = c5m.last;
    final dir = longSignal ? 'buy' : 'sell';
    final risk = (last.high - last.low).abs() * 1.2;

    final proposal = TradeProposal(
      id: const Uuid().v4(),
      symbol: symbol,
      timeframe: '5M',
      direction: dir,
      entry: last.close,
      stopLoss: dir == 'buy' ? last.close - risk : last.close + risk,
      takeProfit: dir == 'buy' ? last.close + risk * 2 : last.close - risk * 2,
      confidence: longSignal ? probs.longProb : probs.shortProb,
      explanation: 'ICT + ONNX confluence',
      regime: features.regime,
      po3Phase: features.po3Phase,
      oteConfluence: features.oteConfluence,
      mtfAligned: features.mtfAligned,
      generatedAt: DateTime.now().toUtc(),
    );

    yield AnalysisResult(proposal: proposal, features: features);
  }
});
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
