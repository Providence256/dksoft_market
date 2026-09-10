import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/common/empty_placeholder_widget.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/dealer_cart_line_row.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartLinesProvider);
    final productRepository = ref.watch(fakeProductsRepositoryProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          'Mon panier',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: items.isEmpty
          ? const EmptyPlaceholderWidget(
              title: 'Aucun panier pour le moment',
              subTitle: 'Les articles que vous ajoutez apparaîtront ici.',
              icon: Icons.shopping_cart_outlined,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                        spreadRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0) const CustomDivider(),
                        Builder(
                          builder: (_) {
                            final item = items[i];
                            final product = productRepository.getProduct(
                              item.productId,
                            );
                            if (product == null) {
                              return const SizedBox.shrink();
                            }

                            return DealerCartLineRow(
                              product: product,
                              item: item,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _BottomBar(subtotal: subtotal),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, -3),
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Sous-total',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  Text(
                    CurrencyFormatter.format(subtotal),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.p12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.goNamed(AppRoute.dealers.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Choisir dealer',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
