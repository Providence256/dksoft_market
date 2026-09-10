import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/dealer/data/fake_dealer_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All the items currently in the cart as a flat list, derived from
/// [cartProvider].
final cartLinesProvider = Provider<List<Item>>((ref) {
  return ref
      .watch(cartProvider)
      .maybeMap(
        data: (cart) => cart.value.toItemList(),
        orElse: () => const [],
      );
});

/// Price for one cart line (unit price, after discount, multiplied by
/// quantity) so the UI can show a real line subtotal instead of a bare unit
/// price.
final cartLineTotalProvider = Provider.autoDispose.family<double, Item>((
  ref,
  item,
) {
  final unitPrice = ref.watch(productPriceProvider(item));
  return unitPrice * item.quantity;
});

/// Sum of every line's total — the cart subtotal.
final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartLinesProvider);

  return items.fold<double>(
    0,
    (sum, item) => sum + ref.watch(cartLineTotalProvider(item)),
  );
});

/// Line total before the merchant's reduction is applied — used to compute
/// the "Remise" (discount) row shown in the dealer cart breakdown.
final cartLineOriginalTotalProvider = Provider.autoDispose.family<double, Item>(
  (ref, item) {
    final unitPrice = ref.watch(productOriginalPriceProvider(item));
    return unitPrice * item.quantity;
  },
);

/// A dealer and the cart lines the client is buying through that dealer.
///
/// The cart is grouped by dealer — not by merchant — because a checkout
/// order and its provision check are always per-dealer (cahier des charges
/// §4.2/§4.3/§6.2): each group here becomes one candidate order.
class DealerCartGroup {
  const DealerCartGroup({required this.dealer, required this.items});

  final Dealer dealer;
  final List<Item> items;

  int get totalQuantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}

/// Total price of a [DealerCartGroup] — what will be checked against that
/// dealer's provision at checkout.
final dealerGroupTotalProvider = Provider.autoDispose
    .family<double, DealerCartGroup>((ref, group) {
      return group.items.fold<double>(
        0,
        (sum, item) => sum + ref.watch(cartLineTotalProvider(item)),
      );
    });

/// Group total before the merchant's reduction — feeds "Prix de l'article"
/// in the dealer cart breakdown.
final dealerGroupOriginalTotalProvider = Provider.autoDispose
    .family<double, DealerCartGroup>((ref, group) {
      return group.items.fold<double>(
        0,
        (sum, item) => sum + ref.watch(cartLineOriginalTotalProvider(item)),
      );
    });

/// "Remise" row: how much the merchant's reduction saved on this group.
final dealerGroupDiscountProvider = Provider.autoDispose
    .family<double, DealerCartGroup>((ref, group) {
      final original = ref.watch(dealerGroupOriginalTotalProvider(group));
      final total = ref.watch(dealerGroupTotalProvider(group));
      return (original - total).clamp(0, double.infinity);
    });

/// Groups the cart's items by dealer (`item.dealerId`), sorted by dealer
/// name, so the client sees one section per dealer — and so checkout can
/// split the cart into one order per dealer.
final cartDealerGroupsProvider = Provider<List<DealerCartGroup>>((ref) {
  final items = ref.watch(cartLinesProvider);
  if (items.isEmpty) return const [];

  final dealerRepository = ref.watch(fakeDealerRepositoryProvider);

  final Map<String, List<Item>> itemsByDealerId = {};
  for (final item in items) {
    itemsByDealerId.putIfAbsent('item', () => []).add(item);
  }

  final groups = itemsByDealerId.entries.map((entry) {
    final dealer =
        dealerRepository.getDealer(entry.key) ??
        const Dealer(
          id: 'unknown',
          name: 'Dealer inconnu',
          phone: '',
          zone: '',
          provisionDisponible: 0,
        );

    return DealerCartGroup(dealer: dealer, items: entry.value);
  }).toList();

  groups.sort((a, b) => a.dealer.name.compareTo(b.dealer.name));

  return groups;
});
