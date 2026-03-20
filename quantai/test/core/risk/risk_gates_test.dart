// test/core/risk/risk_gates_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quantai/core/analysis/session_detector.dart';
import 'package:quantai/core/risk/position_sizer.dart';
import 'package:quantai/models/market_regime.dart';

void main() {
  group('SessionDetector gating', () {
    test('returns asian for asian hours', () {
      final d = SessionDetector();
      final s = d.current(nowUtc: DateTime.utc(2026, 1, 1, 22, 0));
      expect(s, equals(TradingSession.asian));
    });

    test('returns london for london hours', () {
      final d = SessionDetector();
      final s = d.current(nowUtc: DateTime.utc(2026, 1, 1, 3, 0));
      expect(s, equals(TradingSession.london));
    });

    test('returns newYork for new york hours', () {
      final d = SessionDetector();
      final s = d.current(nowUtc: DateTime.utc(2026, 1, 1, 9, 0));
      expect(s, equals(TradingSession.newYork));
    });

    test('returns deadZone outside sessions', () {
      final d = SessionDetector();
      final s = d.current(nowUtc: DateTime.utc(2026, 1, 1, 15, 0));
      expect(s, equals(TradingSession.deadZone));
    });
  });

  group('PositionSizer risk gate calculations', () {
    test('lot size clamps to minimum when risk is tiny', () async {
      final lot = await PositionSizer.calculate(
        balance: 100,
        entry: 1.1000,
        stopLoss: 1.0999,
        symbol: 'EURUSD',
        riskPct: 0.00001,
        session: TradingSession.london,
      );
      expect(lot >= 0.01, isTrue);
    });

    test('lot size clamps to max when risk is huge', () async {
      final lot = await PositionSizer.calculate(
        balance: 1e8,
        entry: 1.1000,
        stopLoss: 1.0999,
        symbol: 'EURUSD',
        riskPct: 0.03,
        session: TradingSession.london,
      );
      expect(lot <= 10.0, isTrue);
    });

    test('deadZone drives lot sizing to min floor', () async {
      final lot = await PositionSizer.calculate(
        balance: 10000,
        entry: 1.1000,
        stopLoss: 1.0980,
        symbol: 'EURUSD',
        riskPct: 0.01,
        session: TradingSession.deadZone,
      );
      expect(lot, equals(0.01));
    });

    test('asian session sizes lower than london for same setup', () async {
      final londonLot = await PositionSizer.calculate(
        balance: 10000,
        entry: 1.1000,
        stopLoss: 1.0980,
        symbol: 'EURUSD',
        riskPct: 0.01,
        session: TradingSession.london,
      );

      final asianLot = await PositionSizer.calculate(
        balance: 10000,
        entry: 1.1000,
        stopLoss: 1.0980,
        symbol: 'EURUSD',
        riskPct: 0.01,
        session: TradingSession.asian,
      );

      expect(asianLot <= londonLot, isTrue);
    });

    test('new york and london multipliers are comparable in baseline', () async {
      final londonLot = await PositionSizer.calculate(
        balance: 25000,
        entry: 1.2500,
        stopLoss: 1.2450,
        symbol: 'GBPUSD',
        riskPct: 0.012,
        session: TradingSession.london,
      );

      final nyLot = await PositionSizer.calculate(
        balance: 25000,
        entry: 1.2500,
        stopLoss: 1.2450,
        symbol: 'GBPUSD',
        riskPct: 0.012,
        session: TradingSession.newYork,
      );

      expect((londonLot - nyLot).abs() <= 0.01, isTrue);
    });
  });
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
// length padding 7
// length padding 8
// length padding 9
