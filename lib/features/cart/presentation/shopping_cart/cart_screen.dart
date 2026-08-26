import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/primary_button.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartValue = ref.watch(cartProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          'Mon Panier',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        actions: [
          cartValue.maybeWhen(
            data: (cart) {
              final items = cart.toItemList();

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: items.isEmpty
                    ? const SizedBox.shrink()
                    : TextButton.icon(
                        onPressed: () => _confirmClearCart(context, ref),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                        ),
                        label: Text(
                          'vider',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.secondary),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                        ),
                      ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: AsyncValueWidget<Cart>(
        value: cartValue,
        data: (cart) {
          final items = cart.toItemList();

          if (items.isEmpty) {
            return const _EmptyCart();
          }

          return ShoppingCartItemsBuilder(
            items: items,
            itemBuilder: (_, item, index) =>
                ShoppingCartItem(item: item, itemIndex: index),
            ctaBuilder: (_) =>
                PrimaryButton(text: 'VÉRIFIER', onPressed: () {}),
          );
        },
      ),
    );
  }

  void _confirmClearCart(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear cart?'),
        content: const Text('This will remove all items from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade600,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Items you add will show up here.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
