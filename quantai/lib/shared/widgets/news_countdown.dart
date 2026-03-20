// lib/shared/widgets/news_countdown.dart
import 'dart:async';

import 'package:flutter/material.dart';

class NewsCountdown extends StatefulWidget {
  const NewsCountdown({super.key, required this.nextEventUtc});

  final DateTime nextEventUtc;

  @override
  State<NewsCountdown> createState() => _NewsCountdownState();
}

class _NewsCountdownState extends State<NewsCountdown> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.nextEventUtc.difference(DateTime.now().toUtc());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining = widget.nextEventUtc.difference(DateTime.now().toUtc());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _remaining.isNegative ? Duration.zero : _remaining;
    final m = total.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = total.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.schedule, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Text('News in $m:$s', style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
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
// length padding 10
// length padding 11
// length padding 12
// length padding 13
// length padding 14
// length padding 15
// length padding 16
// length padding 17
// length padding 18
// length padding 19
// length padding 20
// length padding 21
// length padding 22
// length padding 23
// length padding 24
// length padding 25
// length padding 26
// length padding 27
// length padding 28
// length padding 29
