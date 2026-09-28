import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:dksoft_market/exceptions/error_logger.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/authentication/domain/app_user.dart';
import 'package:dksoft_market/features/cart/data/local/local_cart_repository.dart';
import 'package:dksoft_market/features/cart/data/remote/remote_cart_repository.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/domain/mutable_cart.dart';
import 'package:dksoft_market/features/products/data/products_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_sync_service.g.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (
      previous,
      next,
    ) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.items.isNotEmpty) {
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemsToAdd = await _getLocalItemsToAdd(
          localCart,
          remoteCart,
        );

        final updateRemoteCart = remoteCart.addItems(localItemsToAdd);

        await remoteCartRepository.setCart(uid, updateRemoteCart);

        await localCartRepository.setCart(const Cart());
      }
    } catch (e, st) {
      ref.read(errorLoggerProvider).logError(e, st);
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(
    Cart localCart,
    Cart remoteCart,
  ) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProductsList();

    final localItemsToAdd = <Item>[];
    for (final localItem in localCart.items.entries) {
      final keyParts = localItem.key.split('|');
      final productId = keyParts[0];
      final variationId = keyParts.length > 1 ? keyParts[1] : null;

      final localQuantity = localItem.value;

      final remoteQuantity = remoteCart.items[productId] ?? 0;
      final product = products.firstWhere((product) => product.id == productId);
      final variation = product.variations.firstWhere(
        (variation) => variation.id == variationId,
      );

      final availableQuantity = product.variations.isNotEmpty
          ? variation.stock
          : product.stock;

      final cappedLocalQuantity = min(
        localQuantity,
        availableQuantity - remoteQuantity,
      );

      if (cappedLocalQuantity > 0) {
        localItemsToAdd.add(
          Item(
            productId: productId,
            quantity: cappedLocalQuantity,
            variationId: variationId,
          ),
        );
      }
    }

    return localItemsToAdd;
  }
}

@Riverpod(keepAlive: true)
CartSyncService cartSyncService(Ref ref) {
  return CartSyncService(ref);
}
