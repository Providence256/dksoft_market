import 'package:dksoft_market/core/domain/marchant.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/marchant/data/fake_marchant_repository.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// A vendor and the cart lines the user has for that vendor.
class VendorCartGroup {
  const VendorCartGroup({required this.merchant, required this.items});

  final Merchant merchant;
  final List<Item> items;

  int get totalQuantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}

/// Groups the cart's items by the vendor (`marchandId`) that sells each
/// product — see `core/data/test_products.dart` for how a product links to
/// its merchant.
final cartVendorGroupsProvider = Provider<List<VendorCartGroup>>((ref) {
  final items = ref.watch(cartLinesProvider);
  if (items.isEmpty) return const [];

  final productRepository = ref.watch(fakeProductsRepositoryProvider);
  final merchantRepository = ref.watch(fakeMerchantRepositoryProvider);

  final Map<String, List<Item>> itemsByVendorId = {};

  for (final item in items) {
    final product = productRepository.getProduct(item.productId);
    final vendorId = product?.marchandId ?? 'unknown';

    itemsByVendorId.putIfAbsent(vendorId, () => []).add(item);
  }

  final groups = itemsByVendorId.entries.map((entry) {
    final merchant =
        merchantRepository.getMerchant(entry.key) ??
        Merchant.unknown(entry.key);

    return VendorCartGroup(merchant: merchant, items: entry.value);
  }).toList();

  groups.sort((a, b) => a.merchant.name.compareTo(b.merchant.name));

  return groups;
});
