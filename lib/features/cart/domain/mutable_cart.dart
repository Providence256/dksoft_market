import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';

extension MutableCart on Cart {
  /// Une ligne de panier est identifiée par produit + variation + dealer :
  /// le même produit peut apparaître plusieurs fois dans le panier s'il est
  /// acheté chez des dealers différents (voir Item pour le détail).
  String _generatekey(String productId, String? variationId) {
    return '$productId|${variationId ?? ''}';
  }

  Cart setItem(Item item) {
    final copy = Map<String, int>.from(items);

    final key = _generatekey(item.productId, item.variationId);
    copy[key] = item.quantity;

    return Cart(copy);
  }

  Cart addItem(Item item) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(item.productId, item.variationId);

    copy.update(
      key,
      (value) => item.quantity + value,
      ifAbsent: () => item.quantity,
    );

    return Cart(copy);
  }

  bool containsKey(Item item) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(item.productId, item.variationId);

    if (copy.containsKey(key)) return true;

    return false;
  }

  Cart removeItemById(String productId, String? variationId) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(productId, variationId);
    copy.remove(key);

    return Cart(copy);
  }

  Cart clear() => const Cart({});
}
