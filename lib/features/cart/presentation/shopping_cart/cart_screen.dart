import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/primary_button.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
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

          // Products are ranged by the vendor that sells them, so the
          // shopper can see at a glance which items ship from which
          // merchant (see ProductModal.marchandId).
          final groups = ref.watch(cartVendorGroupsProvider);

          return ShoppingCartItemsBuilder(
            groups: groups,
            itemBuilder: (_, item, index) =>
                ShoppingCartItem(item: item, itemIndex: index),
            ctaBuilder: (context) => PrimaryButton(
              text: 'VÉRIFIER',
              onPressed: () => _startCheckout(context),
            ),
          );
        },
      ),
    );
  }

  void _startCheckout(BuildContext context) {
    // TODO: navigate to the real checkout / shipping flow once it exists.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Le paiement arrive bientôt !')),
    );
  }

  void _confirmClearCart(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Vider le panier ?'),
        content: const Text(
          'Tous les articles seront retirés de votre panier.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade600,
            ),
            onPressed: () {
              ref.read(cartServiceProvider).clearCart();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Vider'),
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
            'Votre panier est vide',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Les articles que vous ajoutez apparaîtront ici.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
