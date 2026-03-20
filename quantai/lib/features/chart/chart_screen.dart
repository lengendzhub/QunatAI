// lib/features/chart/chart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/candles_provider.dart';
import '../../shared/widgets/ambient_background.dart';
import '../../shared/widgets/symbol_chip.dart';
import 'candlestick_painter.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({required this.symbol, super.key});

  final String symbol;

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  late String _symbol;
  String _timeframe = '5M';
  final symbols = const <String>['EURUSD', 'GBPUSD', 'USDJPY', 'AUDUSD', 'USDCAD', 'XAUUSD', 'XTIUSD', 'BTCUSD', 'ETHUSD'];
  final tfs = const <String>['1M', '5M', '15M', '1H', '4H', '1D'];

  @override
  void initState() {
    super.initState();
    _symbol = widget.symbol;
  }

  @override
  Widget build(BuildContext context) {
    final candlesAsync = ref.watch(candlesProvider((symbol: _symbol, timeframe: _timeframe)));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: symbols.length,
                  itemBuilder: (_, i) => SymbolChip(
                    symbol: symbols[i],
                    selected: symbols[i] == _symbol,
                    onTap: () => setState(() => _symbol = symbols[i]),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: tfs.length,
                  itemBuilder: (_, i) => ChoiceChip(
                    label: Text(tfs[i]),
                    selected: tfs[i] == _timeframe,
                    onSelected: (_) => setState(() => _timeframe = tfs[i]),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: candlesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (candles) => InteractiveViewer(
                    maxScale: 6,
                    minScale: 1,
                    child: CustomPaint(
                      size: const Size(double.infinity, double.infinity),
                      painter: CandlestickPainter(candles: candles, scrollOffset: 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
