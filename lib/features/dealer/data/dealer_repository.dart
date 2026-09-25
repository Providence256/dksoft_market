import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/core/domain/pickup_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the public dealer directory the client picks from at checkout
/// (§4.3 step 6) from the shared `dealer_profiles` Firestore collection —
/// the same collection the dealer app's debug "Seed Firestore" screen
/// populates, so both apps show the same dealers.
class DealerRepository {
  DealerRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static const _collection = 'dealers';

  DealerModel _fromDoc(Map<String, dynamic> map) {
    final rawAddress = map['address'];

    final address = rawAddress is Map
        ? PickupLocation.fromMap(Map<String, dynamic>.from(rawAddress))
        : null;

    return DealerModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String?,
      address: address,
      provisionDisponible:
          (map['provisionDisponible'] as num?)?.toDouble() ?? 0.0,
      provisionBloquee: (map['provisionBloquee'] as num?)?.toDouble() ?? 0.0,
      provisonRetirable: (map['provisonRetirable'] as num?)?.toDouble() ?? 0.0,
      status: DealerStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => DealerStatus.enAttente,
      ),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Stream<List<DealerModel>> watchAllDealers() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => _fromDoc(doc.data())).toList(),
        );
  }
}

final dealerRepositoryProvider = Provider<DealerRepository>((ref) {
  return DealerRepository(FirebaseFirestore.instance);
});

final watchAllDealersProvider = StreamProvider.autoDispose<List<DealerModel>>((
  ref,
) {
  return ref.watch(dealerRepositoryProvider).watchAllDealers();
});

/// Synchronous lookup derived from the live list [watchAllDealersProvider]
/// already streams — keeps call sites using a plain `Dealer?` (not
/// `AsyncValue<Dealer?>`), unchanged now that dealers come from Firestore
/// instead of an in-memory constant.
final dealerByIdProvider = Provider.family<DealerModel?, String>((ref, id) {
  final dealers = ref.watch(watchAllDealersProvider).value ?? const [];
  for (final dealer in dealers) {
    if (dealer.id == id) return dealer;
  }
  return null;
});
