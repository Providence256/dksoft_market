import 'dart:math';

import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/cart/data/local/local_cart_repository.dart';
import 'package:dksoft_market/features/cart/data/remote/remote_cart_repository.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/domain/mutable_cart.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user != null) {
      final cart = ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);

      return cart;
    } else {
      final cart = ref.read(localCartRepositoryProvider).fetchCart();

      return cart;
    }
  }

  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user != null) {
      await ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);

    await _setCart(updated);
  }

  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);

    await _setCart(updated);
  }

  Future<void> removeItem(
    String productId,
    String? variationId,
    String dealerId,
  ) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId, variationId, dealerId);

    await _setCart(updated);
  }

  Future<void> clearCart() async {
    await _setCart(const Cart());
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});

final cartProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesProvider).value;

  if (user != null) {
    return ref.read(remoteCartRepositoryProvider).watchCart(user.uid);
  } else {
    return ref.watch(localCartRepositoryProvider).watchCart();
  }
});

/// Total number of units in the cart (sum of every line's quantity), used
/// e.g. to badge the cart icon in the bottom navigation bar.
final cartItemsCountProvider = Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .maybeMap(
        data: (cart) => cart.value.items.values.fold<int>(
          0,
          (sum, quantity) => sum + quantity,
        ),
        orElse: () => 0,
      );
});

final itemAvailableQuantityProvider = Provider.autoDispose
    .family<int, ProductModal>((ref, product) {
      final cart = ref.watch(cartProvider).value;
      final selectedVariation = ref.watch(productVariationControllerProvider);

      int finalQuantity;

      if (cart != null) {
        int quantityInCart = 0;

        cart.items.forEach((key, quantity) {
          final keyParts = key.split('|');
          final productId = keyParts[0];
          final variationId = (keyParts.length > 1 && keyParts[1].isNotEmpty)
              ? keyParts[1]
              : null;

          if (productId == product.id) {
            if (variationId != null && selectedVariation.id == variationId) {
              quantityInCart += quantity;
            } else if (variationId == null) {
              quantityInCart += quantity;
            }
          }
        });

        //Substract it from the product available quantity
        if (product.variations.isNotEmpty && selectedVariation.id.isNotEmpty) {
          finalQuantity = max(0, selectedVariation.stock - quantityInCart);
        } else {
          finalQuantity = max(0, product.stock - quantityInCart);
        }
        return finalQuantity;
      } else {
        return product.stock;
      }
    });

final cartAvailableQuantityProvider = Provider.autoDispose.family<int, Item>((
  ref,
  item,
) {
  final cart = ref.watch(cartProvider).value;
  final product = ref.watch(watchProductProvider(item.productId)).value;

  if (cart == null || product == null) {
    return item.quantity;
  }

  ProductVariation? variation;

  if (item.variationId != null) {
    for (final v in product.variations) {
      if (v.id == item.variationId) {
        variation = v;
        break;
      }
    }
  }

  final totalCartQuantity = cart.items.entries.fold<int>(0, (sum, entry) {
    final keyParts = entry.key.split('|');

    final productId = keyParts[0];
    final variationId = (keyParts.length > 1 && keyParts[1].isNotEmpty)
        ? keyParts[1]
        : null;

    if (productId == item.productId && variationId == item.variationId) {
      return sum + entry.value;
    }

    return sum;
  });

  final availableStock = variation?.stock ?? product.stock;

  return max(0, availableStock - totalCartQuantity);
});
