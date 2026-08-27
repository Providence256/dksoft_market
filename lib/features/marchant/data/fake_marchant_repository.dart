import 'package:dksoft_market/core/data/test_marchant.dart';
import 'package:dksoft_market/core/domain/marchant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeMerchantRepository {
  final List<Merchant> _merchants = kTestMerchants;

  /// Synchronous lookup so grouping/UI code can resolve a vendor without
  /// juggling another async stream (mirrors `FakeProductRepository.getProduct`).
  Merchant? getMerchant(String id) {
    try {
      return _merchants.firstWhere((merchant) => merchant.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Merchant> getMerchantsList() => _merchants;
}

final fakeMerchantRepositoryProvider = Provider<FakeMerchantRepository>((ref) {
  return FakeMerchantRepository();
});

/// Resolves a merchant by id, falling back to [Merchant.unknown] so the UI
/// never has to null-check a missing vendor record.
final merchantByIdProvider = Provider.family<Merchant, String>((ref, id) {
  final repository = ref.watch(fakeMerchantRepositoryProvider);
  return repository.getMerchant(id) ?? Merchant.unknown(id);
});
