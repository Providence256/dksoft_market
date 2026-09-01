import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

class ShoppingCartController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartController({required this.cartService}) : super(AsyncData(null));

  final CartService cartService;

  Future<void> updateItemQuantity(
    String productId,
    int quantity,
    String? variationId,
    String dealerId,
  ) async {
    state = AsyncLoading();
    final update = Item(
      productId: productId,
      quantity: quantity,
      dealerId: dealerId,
      variationId: variationId,
    );

    state = await AsyncValue.guard(() => cartService.setItem(update));
  }
}

final shoppingCartControllerProvider =
    StateNotifierProvider<ShoppingCartController, AsyncValue<void>>((ref) {
      return ShoppingCartController(
        cartService: ref.watch(cartServiceProvider),
      );
    });
