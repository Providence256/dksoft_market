import 'package:dksoft_market/core/data/test_merchants.dart';
import 'package:dksoft_market/core/domain/merchant.dart';
import 'package:dksoft_market/core/domain/pickup_location.dart';
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

  List<PickupLocation> getPickupLocationsByMerchantId(String merchantId) {
    final merchant = getMerchant(merchantId);

    return merchant?.pickupLocations ?? [];
  }

  PickupLocation? getDefaultPickupLocationByMerchantId(String merchantId) {
    final merchant = getMerchant(merchantId);

    return merchant?.defaultPickupLocation;
  }

  PickupLocation? getPickupLocationById({
    required String merchantId,
    required String pickupLocationId,
  }) {
    final merchant = getMerchant(merchantId);
    if (merchant == null) return null;

    try {
      return merchant.pickupLocations.firstWhere(
        (location) => location.id == pickupLocationId,
      );
    } catch (e) {
      return null;
    }
  }
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

final merchantdefaultPickupLocationProvider =
    Provider.family<PickupLocation?, String>((ref, id) {
      final repository = ref.watch(fakeMerchantRepositoryProvider);

      return repository.getDefaultPickupLocationByMerchantId(id);
    });
