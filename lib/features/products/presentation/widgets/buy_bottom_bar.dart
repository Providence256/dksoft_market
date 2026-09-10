import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class BuyBottomBar extends ConsumerWidget {
  const BuyBottomBar({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariation = ref.watch(selectedVariationProvider);
    final isInCart = ref.watch(
      isItemInCartProvider((
        productId: product.id,
        variationId: selectedVariation.id,
      )),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton.icon(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedShoppingBasketAdd03,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {
            isInCart
                ? context.goNamed(AppRoute.cart.name)
                : ref
                      .read(addToCartControllerProvider.notifier)
                      .addItem(product.id, selectedVariation.id);
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: isInCart
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,

            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          label: Text(
            isInCart ? 'Voir Panier' : 'Ajouter au Panier',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
