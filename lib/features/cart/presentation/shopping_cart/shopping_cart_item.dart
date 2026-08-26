import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/shopping_cart_contents.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    super.key,
    required this.item,
    required this.itemIndex,
  });

  final Item item;
  final int itemIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(watchProductProvider(item.productId));
    return AsyncValueWidget<ProductModal?>(
      value: productValue,
      data: (product) => ShoppingCartContents(
        product: product!,
        item: item,
        itemIndex: itemIndex,
      ),
    );
  }
}
