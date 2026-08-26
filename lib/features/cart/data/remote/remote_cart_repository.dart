import 'package:dksoft_market/features/cart/data/remote/remote_cart_repository_impl.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);
  Stream<Cart> watchCart(String uid);
  Future<void> setCart(String uid, Cart cart);
}

final remoteCartRepositoryProvider = Provider<RemoteCartRepository>((ref) {
  return RemoteCartRepositoryImpl();
});
