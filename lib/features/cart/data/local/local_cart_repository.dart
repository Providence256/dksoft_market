import 'package:dksoft_market/features/cart/data/local/local_cart_repository_impl.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalCartRepository {
  Future<Cart> fetchCart();
  Stream<Cart> watchCart();
  Future<void> setCart(Cart cart);
}

final localCartRepositoryProvider = Provider<LocalCartRepository>((ref) {
  return LocalCartRepositoryImpl();
});
