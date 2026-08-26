import 'package:dksoft_market/features/cart/data/local/local_cart_repository.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/utils/validators/in_memory_store.dart';

class LocalCartRepositoryImpl implements LocalCartRepository {
  final _cart = InMemoryStore<Cart>(Cart());

  @override
  Future<Cart> fetchCart() {
    return Future.value(_cart.value);
  }

  @override
  Future<void> setCart(Cart cart) async {
    _cart.value = cart;
  }

  @override
  Stream<Cart> watchCart() {
    return _cart.stream;
  }
}
