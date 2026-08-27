import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/shopping_cart_controller.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

class ShoppingCartContents extends ConsumerWidget {
  const ShoppingCartContents({
    super.key,
    required this.product,
    required this.item,
    required this.itemIndex,
  });
  final ProductModal product;
  final Item item;
  final int itemIndex;

  void _remove(WidgetRef ref) {
    ref.read(cartServiceProvider).removeItem(item.productId, item.variationId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariationValue = ref.watch(
      productVariationProvider((
        productId: item.productId,
        variationId: item.variationId,
      )),
    );
    final theme = Theme.of(context);
    final unitPrice = ref.watch(productPriceProvider(item));
    final lineTotal = ref.watch(cartLineTotalProvider(item));

    return Dismissible(
      key: ValueKey('cart_item_${item.productId}_${item.variationId}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _remove(ref),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ResponsiveCenter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  product.images.isNotEmpty ? product.images.first : '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ),
                        _RemoveButton(onTap: () => _remove(ref)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    AsyncValueWidget<ProductVariation?>(
                      value: selectedVariationValue,
                      data: (variation) {
                        if (variation == null) return const SizedBox.shrink();

                        return Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: variation.attributeValues.entries
                              .map((entry) => _AttributeTag(label: entry.value))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.quantity > 1)
                                Text(
                                  '${CurrencyFormatter.format(unitPrice)} / unité',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                child: Text(
                                  CurrencyFormatter.format(lineTotal),
                                  key: ValueKey(lineTotal),
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        QuantityStepper(item: item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedDelete02,
          color: Colors.red,
        ),
      ),
    );
  }
}

/// Small pill showing a selected attribute (e.g. "Color: Black"), with a
/// tiny color dot when the value resolves to a real color.
class _AttributeTag extends StatelessWidget {
  const _AttributeTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact +/- quantity stepper used inside each cart row.
class QuantityStepper extends ConsumerWidget {
  const QuantityStepper({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemQuantity = ref.watch(cartAvailableQuantityProvider(item));
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey.withValues(alpha: 0.08),
      ),
      child: ItemCartQuantitySelector(
        // Cap on real remaining stock instead of an arbitrary hardcoded
        // number, so items with high stock (e.g. groceries) aren't
        // artificially limited to 10.
        quantity: item.quantity,
        maxQuantity: itemQuantity + item.quantity,
        onChanged: (quantity) => ref
            .read(shoppingCartControllerProvider.notifier)
            .updateItemQuantity(item.productId, quantity, item.variationId),
      ),
    );
  }
}

class ItemCartQuantitySelector extends StatelessWidget {
  const ItemCartQuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    this.itemIndex,
    this.onChanged,
  });

  final int quantity;
  final int maxQuantity;
  final int? itemIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepperButton(
          context: context,
          icon: Icons.remove_rounded,
          onTap: quantity > 1 ? () => onChanged!.call(quantity - 1) : null,
        ),
        SizedBox(
          width: 26,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        _stepperButton(
          context: context,
          icon: Icons.add_rounded,
          onTap: quantity < maxQuantity
              ? () => onChanged!.call(quantity + 1)
              : null,
        ),
      ],
    );
  }

  Widget _stepperButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withValues(alpha: 0.15),
          ),
          child: Icon(
            icon,
            size: 14,
            color: enabled ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
