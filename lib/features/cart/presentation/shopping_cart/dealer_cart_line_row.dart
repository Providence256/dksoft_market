import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/shopping_cart_controller.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

/// One row of the dealer cart list: thumbnail, name + unit tag, price (with
/// the merchant's original price struck through when discounted), and a
/// trash/quantity/plus pill on the right.
class DealerCartLineRow extends ConsumerWidget {
  const DealerCartLineRow({
    super.key,
    required this.product,
    required this.item,
  });

  final ProductModal product;
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unitPrice = ref.watch(productPriceProvider(item));
    final originalUnitPrice = ref.watch(productOriginalPriceProvider(item));
    final hasDiscount = originalUnitPrice > unitPrice + 0.01;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              product.images.isNotEmpty ? product.images.first : '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 50,
                height: 50,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Pc',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      CurrencyFormatter.format(unitPrice),
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (hasDiscount)
                      Text(
                        CurrencyFormatter.format(originalUnitPrice),
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: Colors.grey.withValues(alpha: 0.7),
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _QuantityPill(item: item),
        ],
      ),
    );
  }
}

/// [trash/–] [qty] [+] pill: with a single unit, the left action deletes
/// the line entirely; once quantity ≥ 2 it becomes a normal decrement.
class _QuantityPill extends ConsumerWidget {
  const _QuantityPill({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuantity = ref.watch(cartAvailableQuantityProvider(item));
    final maxQuantity = availableQuantity + item.quantity;

    void updateQuantity(int quantity) {
      ref
          .read(shoppingCartControllerProvider.notifier)
          .updateItemQuantity(
            item.productId,
            quantity,
            item.variationId,
            item.dealerId,
          );
    }

    void remove() {
      ref
          .read(cartServiceProvider)
          .removeItem(item.productId, item.variationId, item.dealerId);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: item.quantity > 1
                ? () => updateQuantity(item.quantity - 1)
                : remove,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: HugeIcon(
                icon: item.quantity > 1
                    ? HugeIcons.strokeRoundedRemove01
                    : HugeIcons.strokeRoundedDelete02,
                color: item.quantity > 1
                    ? Colors.grey[700]
                    : Colors.red.shade400,
                size: 18,
              ),
            ),
          ),
          SizedBox(
            width: 22,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: item.quantity < maxQuantity
                ? () => updateQuantity(item.quantity + 1)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.add_rounded,
                size: 18,
                color: item.quantity < maxQuantity
                    ? Colors.grey[700]
                    : Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
