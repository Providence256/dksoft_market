import 'package:dksoft_market/core/data/test_dealers.dart';
import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/core/domain/dealer_listing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeDealerRepository {
  final List<Dealer> _dealers = kTestDealers;
  final List<DealerListing> _listings = kTestDealerListings;

  Dealer? getDealer(String id) {
    try {
      return _dealers.firstWhere((dealer) => dealer.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Toutes les offres actives (dealer + marge) pour un produit donné,
  /// triées du moins cher au plus cher.
  List<DealerListing> getListingsForProduct(String productId) {
    final listings = _listings
        .where((l) => l.productId == productId && l.actif)
        .toList();

    listings.sort((a, b) => a.margePourcentage.compareTo(b.margePourcentage));

    return listings;
  }

  List<DealerListing> getListingsForDealer(String dealerId) {
    return _listings.where((l) => l.dealerId == dealerId).toList();
  }
}

final fakeDealerRepositoryProvider = Provider<FakeDealerRepository>((ref) {
  return FakeDealerRepository();
});

final dealerByIdProvider = Provider.family<Dealer?, String>((ref, id) {
  return ref.watch(fakeDealerRepositoryProvider).getDealer(id);
});

/// Offres disponibles pour un produit, une par dealer qui le propose.
final dealerListingsForProductProvider =
    Provider.family<List<DealerListing>, String>((ref, productId) {
      return ref
          .watch(fakeDealerRepositoryProvider)
          .getListingsForProduct(productId);
    });
