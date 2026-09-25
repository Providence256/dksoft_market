import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeDealerRepository {
  final List<DealerModel> _dealers = [];

  DealerModel? getDealer(String id) {
    try {
      return _dealers.firstWhere((dealer) => dealer.id == id);
    } catch (e) {
      return null;
    }
  }

  Stream<List<DealerModel>> watchAllDealers() async* {
    yield _dealers;
  }
}

final fakeDealerRepositoryProvider = Provider<FakeDealerRepository>((ref) {
  return FakeDealerRepository();
});

final dealerByIdProvider = Provider.family<DealerModel?, String>((ref, id) {
  return ref.watch(fakeDealerRepositoryProvider).getDealer(id);
});

final watchAllDealersProvider = StreamProvider.autoDispose<List<DealerModel>>((
  ref,
) {
  final repository = ref.watch(fakeDealerRepositoryProvider);

  return repository.watchAllDealers();
});
