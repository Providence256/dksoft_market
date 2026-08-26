import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';

extension MutableCart on Cart {
  String _generatekey(String productId, String? variationId) {
    if (variationId == null) {
      return productId;
    } else {
      return '$productId|$variationId';
    }
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

  Cart removeItemById(String productId, String? variationId) {
    final copy = Map<String, int>.from(items);
    final key = _generatekey(productId, variationId);
    copy.remove(key);

    return Cart(copy);
  }
}
