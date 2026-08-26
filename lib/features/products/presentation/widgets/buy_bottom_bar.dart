import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

class BuyBottomBar extends ConsumerWidget {
  const BuyBottomBar({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuantity = ref.watch(itemAvailableQuantityProvider(product));
    final selectedVariation = ref.watch(selectedVariationProvider);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: availableQuantity > 0
                    ? () {
                        ref
                            .read(addToCartControllerProvider.notifier)
                            .addItem(product.id, selectedVariation.id);

                        context.goNamed(AppRoute.cart.name);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: availableQuantity > 0
                    ? HugeIcon(
                        icon: HugeIcons.strokeRoundedShoppingBasketAdd03,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : HugeIcon(icon: HugeIconsStrokeRounded.addCircleHalfDot),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 20,
              ),

              iconAlignment: IconAlignment.end,
              label: Text(
                'Choisir Dealer',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
