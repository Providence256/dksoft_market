import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class DealerCartCard extends ConsumerWidget {
  const DealerCartCard({super.key, required this.group});

  final DealerCartGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dealer = group.dealer;
    final total = ref.watch(dealerGroupTotalProvider(group));
    final productRepository = ref.watch(fakeProductsRepositoryProvider);

    final thumbnails = group.items
        .map((item) => productRepository.getProduct(item.productId))
        .where((p) => p != null && p.images.isNotEmpty)
        .map((p) => p!.images.first)
        .toList();
    final extraCount = group.items.length - 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  dealer.name.isNotEmpty ? dealer.name[0].toUpperCase() : '?',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dealer.name,
                      style: theme.textTheme.bodyMedium!.copyWith(),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedMotorbike02,
                          size: 15,
                          color: Colors.grey[500],
                        ),

                        const SizedBox(width: 4),
                        Text(
                          _estimatedDelivery(dealer),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == 'clear') _clearDealerCart(ref);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'clear', child: Text('Vider ce panier')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 34 + (thumbnails.length.clamp(0, 3) - 1) * 20 + 20,
                  height: 40,
                  child: Stack(
                    children: [
                      for (var i = 0; i < thumbnails.length.clamp(0, 3); i++)
                        Positioned(
                          left: i * 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(34),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(34),
                              ),
                              child: Image.asset(
                                thumbnails[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                      if (extraCount > 0)
                        Positioned(
                          left: thumbnails.length.clamp(0, 3) * 20,
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(34),
                            ),
                            child: Text(
                              '+$extraCount',
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  CurrencyFormatter.format(total),
                  style: theme.textTheme.bodyMedium!.copyWith(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Flexible(
                child: TextButton.icon(
                  onPressed: () {}, // TODO: retour au catalogue de ce dealer
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedAddCircle,
                    size: 15,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    "Ajouter d'autres articles",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.copyWith(color: AppColors.primary),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.goNamed(
                    AppRoute.dealerCart.name,
                    pathParameters: {'id': dealer.id},
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Voir mon panier',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _clearDealerCart(WidgetRef ref) {
    final cartService = ref.read(cartServiceProvider);
    for (final item in group.items) {
      cartService.removeItem(item.productId, item.variationId);
    }
  }

  /// Estimation de livraison déterministe (placeholder tant que la
  /// géolocalisation réelle des motards n'est pas branchée — §12.1/§16).
  String _estimatedDelivery(Dealer dealer) {
    final seed = dealer.id.hashCode.abs();
    final etaMin = 15 + (seed % 30);
    final etaMax = etaMin + 10 + (seed % 15);
    final km = 0.5 + (seed % 400) / 100;
    return '$etaMin-$etaMax min (${km.toStringAsFixed(2)} km)';
  }
}
