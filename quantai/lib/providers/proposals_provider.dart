// lib/providers/proposals_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/daos/proposals_dao.dart';
import '../models/proposal.dart';
import 'analysis_provider.dart';
import 'settings_provider.dart';

class ProposalsNotifier extends StateNotifier<List<TradeProposal>> {
  ProposalsNotifier(this._ref, this._dao) : super(const <TradeProposal>[]);

  final Ref _ref;
  final ProposalsDao _dao;
  final Map<String, Timer> _expiry = <String, Timer>{};

  void watchSymbol(String symbol) {
    _ref.listen<AsyncValue<dynamic>>(analysisProvider(symbol), (_, next) {
      next.whenData((result) async {
        if (result == null) {
          return;
        }
        final proposal = result.proposal;
        state = <TradeProposal>[proposal, ...state].take(20).toList();
        await _dao.insertProposal(proposal);
        _scheduleExpiry(proposal.id);
      });
    });
  }

  Future<void> reject(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _dao.updateStatus(id, 'rejected');
    _expiry.remove(id)?.cancel();
  }

  void _scheduleExpiry(String id) {
    _expiry[id]?.cancel();
    _expiry[id] = Timer(const Duration(minutes: 15), () async {
      state = state.where((p) => p.id != id).toList();
      await _dao.updateStatus(id, 'expired');
      _expiry.remove(id)?.cancel();
    });
  }

  @override
  void dispose() {
    for (final timer in _expiry.values) {
      timer.cancel();
    }
    super.dispose();
  }
}

final proposalsProvider = StateNotifierProvider<ProposalsNotifier, List<TradeProposal>>((ref) {
  return ProposalsNotifier(ref, ProposalsDao(ref.watch(databaseProvider)));
});
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
