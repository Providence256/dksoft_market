import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_to_cart_controller.g.dart';

@riverpod
class AddToCartController extends _$AddToCartController {
  @override
  AsyncValue<int> build() {
    return AsyncData(1);
  }

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(String productId, String? variationId) async {
    final item = Item(
      productId: productId,
      quantity: state.value ?? 1,
      variationId: variationId,
    );

    state = const AsyncLoading<int>();
    final cartService = ref.read(cartServiceProvider);
    final value = await AsyncValue.guard(() => cartService.addItem(item));

    if (value.hasError) {
      state = AsyncError(value.error!, value.stackTrace ?? StackTrace.current);

      return;
    }

    state = AsyncData(1);
  }
}
