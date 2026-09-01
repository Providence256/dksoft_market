import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';

extension MutableCart on Cart {
  /// Une ligne de panier est identifiée par produit + variation + dealer :
  /// le même produit peut apparaître plusieurs fois dans le panier s'il est
  /// acheté chez des dealers différents (voir Item pour le détail).
  String _generatekey(String productId, String? variationId, String dealerId) {
    return '$productId|${variationId ?? ''}|$dealerId';
  }

  Cart setItem(Item item) {
    final copy = Map<String, int>.from(items);

    final key = _generatekey(item.productId, item.variationId, item.dealerId);
    copy[key] = item.quantity;

    return Cart(copy);
  }

  Cart addItem(Item item) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(item.productId, item.variationId, item.dealerId);

    copy.update(
      key,
      (value) => item.quantity + value,
      ifAbsent: () => item.quantity,
    );

    return Cart(copy);
  }

  Cart removeItemById(String productId, String? variationId, String dealerId) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(productId, variationId, dealerId);
    copy.remove(key);

    return Cart(copy);
  }

  Cart clear() => const Cart({});
}
