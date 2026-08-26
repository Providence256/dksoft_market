import 'package:dksoft_market/features/cart/data/remote/remote_cart_repository.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/utils/validators/in_memory_store.dart';

class RemoteCartRepositoryImpl implements RemoteCartRepository {
  final _carts = InMemoryStore<Map<String, Cart>>({});

  @override
  Future<Cart> fetchCart(String uid) {
    return Future.value(_carts.value[uid] ?? Cart());
  }

  @override
  Future<void> setCart(String uid, Cart cart) async {
    final carts = _carts.value;
    carts[uid] = cart;

    _carts.value = carts;
  }

  @override
  Stream<Cart> watchCart(String uid) {
    return _carts.stream.map((cartData) => cartData[uid] ?? Cart());
  }
}
