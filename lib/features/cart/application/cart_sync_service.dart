import 'dart:math';

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

  final Map<String, Future<void>> _inFlight = {};

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (
      previous,
      next,
    ) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        syncFor(user.uid);
      }
    });
  }

  Future<void> syncFor(String uid) {
    final running = _inFlight[uid];
    if (running != null) return running;

    final future = _moveItemsToRemoteCart(uid).whenComplete(() {
      _inFlight.remove(uid);
    });
    _inFlight[uid] = future;
    return future;
  }

  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();
      if (localCart.items.isEmpty) return;

      final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
      final remoteCart = await remoteCartRepository.fetchCart(uid);
      final localItemsToAdd = await _getLocalItemsToAdd(localCart, remoteCart);

      final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
      await remoteCartRepository.setCart(uid, updatedRemoteCart);

      // On ne vide le local qu'après l'écriture distante réussie.
      await localCartRepository.setCart(const Cart());
    } catch (e, st) {
      // En cas d'erreur le panier local reste intact : rien n'est perdu.
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

    for (final entry in localCart.items.entries) {
      final keyParts = entry.key.split('|');
      final productId = keyParts[0];

      final variationId = (keyParts.length > 1 && keyParts[1].isNotEmpty)
          ? keyParts[1]
          : null;

      final localQuantity = entry.value;

      final product = products.where((p) => p.id == productId).firstOrNull;
      if (product == null) continue;

      final variation = variationId == null
          ? null
          : product.variations.where((v) => v.id == variationId).firstOrNull;

      if (variationId != null && variation == null) continue;

      final availableQuantity = variation?.stock ?? product.stock;

      final remoteQuantity = remoteCart.items[entry.key] ?? 0;

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
