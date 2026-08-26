import 'dart:math';

import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/widgets/item_quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductQuantity extends ConsumerWidget {
  const ProductQuantity({super.key, required this.product});
  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(addToCartControllerProvider).value ?? 1;
    final availableQuantity = ref.watch(itemAvailableQuantityProvider(product));
    final state = ref.watch(addToCartControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
        ItemQuantitySelector(
          quantity: quantity,
          maxQuantity: min(availableQuantity, 10),
          onChanged: state.isLoading
              ? null
              : (quantity) => ref
                    .read(addToCartControllerProvider.notifier)
                    .updateQuantity(quantity),
        ),
      ],
    );
  }
}
