import 'package:dksoft_market/core/data/test_dealers.dart';
import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeDealerRepository {
  final List<Dealer> _dealers = kTestDealers;

  Dealer? getDealer(String id) {
    try {
      return _dealers.firstWhere((dealer) => dealer.id == id);
    } catch (e) {
      return null;
    }
  }

  Stream<List<Dealer>> watchAllDealers() async* {
    yield _dealers;
  }
}

final fakeDealerRepositoryProvider = Provider<FakeDealerRepository>((ref) {
  return FakeDealerRepository();
});

final dealerByIdProvider = Provider.family<Dealer?, String>((ref, id) {
  return ref.watch(fakeDealerRepositoryProvider).getDealer(id);
});

final watchAllDealersProvider = StreamProvider.autoDispose<List<Dealer>>((ref) {
  final repository = ref.watch(fakeDealerRepositoryProvider);

  return repository.watchAllDealers();
});
