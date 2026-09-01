import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:dksoft_market/features/dealer/data/fake_dealer_repository.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/features/products/presentation/controller/selected_dealer_controller.dart';
import 'package:dksoft_market/features/products/presentation/widgets/dealer_picker_sheet.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:toastification/toastification.dart';

/// Bottom bar on the product page. A client always buys through a dealer
/// (§3.1/§4.3 du cahier des charges), so "Ajouter au panier" stays disabled
/// until a dealer offer has been picked via [showDealerPicker].
class BuyBottomBar extends ConsumerWidget {
  const BuyBottomBar({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuantity = ref.watch(itemAvailableQuantityProvider(product));
    final selectedVariation = ref.watch(selectedVariationProvider);
    final selectedDealerId = ref.watch(selectedDealerProvider);
    final selectedDealer = selectedDealerId == null
        ? null
        : ref.watch(dealerByIdProvider(selectedDealerId));

    final canAdd =
        availableQuantity > 0 &&
        selectedDealer != null &&
        selectedDealer.estValide;

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
                onPressed: canAdd
                    ? () {
                        ref
                            .read(addToCartControllerProvider.notifier)
                            .addItem(
                              product.id,
                              selectedVariation.id,
                              selectedDealer.id,
                            );

                        context.goNamed(AppRoute.cart.name);
                      }
                    : () {
                        toastification.show(
                          type: ToastificationType.warning,
                          style: ToastificationStyle.fillColored,
                          title: Text(
                            'Sélectionnez un dealer pour ajouter ce produit au panier',
                          ),
                          autoCloseDuration: Duration(seconds: 3),
                          alignment: Alignment.bottomRight,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAdd
                      ? Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.7)
                      : Colors.grey.withValues(alpha: 0.2),
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
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => showDealerPicker(context, product),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 20,
                  color: Colors.white,
                ),
                iconAlignment: IconAlignment.end,
                label: Text(
                  selectedDealer != null
                      ? selectedDealer.name
                      : 'Choisir Dealer',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
