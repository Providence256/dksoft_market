import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/application/checkout_service.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/dealer_cart_line_row.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class DealerCartScreen extends ConsumerStatefulWidget {
  const DealerCartScreen({super.key, required this.dealerId});

  final String dealerId;

  @override
  ConsumerState<DealerCartScreen> createState() => _DealerCartScreenState();
}

class _DealerCartScreenState extends ConsumerState<DealerCartScreen> {
  bool _breakdownExpanded = true;

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(cartDealerGroupsProvider);
    final matches = groups.where((g) => g.dealer.id == widget.dealerId);
    final group = matches.isEmpty ? null : matches.first;

    if (group == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final productRepository = ref.watch(fakeProductsRepositoryProvider);
    final total = ref.watch(dealerGroupTotalProvider(group));
    final originalTotal = ref.watch(dealerGroupOriginalTotalProvider(group));
    final discount = ref.watch(dealerGroupDiscountProvider(group));

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            _Header(group: group),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
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
                        for (var i = 0; i < group.items.length; i++) ...[
                          if (i > 0) const CustomDivider(),
                          Builder(
                            builder: (_) {
                              final item = group.items[i];
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
                        InkWell(
                          onTap:
                              () {}, // TODO: retour au catalogue de ce dealer
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedAddCircle,
                                  color: Colors.black,
                                  size: 18,
                                ),

                                const SizedBox(width: 10),
                                Text(
                                  "Ajouter d'autres articles",
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 3),
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PriceBreakdown(
              itemsPrice: originalTotal,
              discount: discount,
              subtotal: total,
              expanded: _breakdownExpanded,
              onToggle: () =>
                  setState(() => _breakdownExpanded = !_breakdownExpanded),
            ),
            _ConfirmButton(group: group, total: total),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.group});

  final DealerCartGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            offset: Offset(0, 3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Panier – ${group.dealer.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  group.items.length > 1
                      ? '${group.items.length} articles ajoutés'
                      : '${group.items.length} article ajouté',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmClearGroup(context, group),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearGroup(BuildContext context, DealerCartGroup group) {
    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Vider ce panier ?'),
          content: Text('Les articles de ${group.dealer.name} seront retirés.'),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: const Text('Annuler'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade600,
              ),
              onPressed: () {
                final cartService = ref.read(cartServiceProvider);
                for (final item in group.items) {
                  cartService.removeItem(
                    item.productId,
                    item.variationId,
                    item.dealerId,
                  );
                }
                dialogContext.pop();
              },
              child: const Text('Vider'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.itemsPrice,
    required this.discount,
    required this.subtotal,
    required this.expanded,
    required this.onToggle,
  });

  final double itemsPrice;
  final double discount;
  final double subtotal;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                _breakdownRow(theme, "Prix de l'article", itemsPrice),
                const SizedBox(height: 8),
                _breakdownRow(theme, 'Remise', -discount),
                const SizedBox(height: 8),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                Text(
                  'Sous-total',
                  style: theme.textTheme.bodyLarge!.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 4),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.black,
                ),
                const Spacer(),
                Text(
                  CurrencyFormatter.format(subtotal),
                  style: theme.textTheme.bodyLarge!.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _breakdownRow(ThemeData theme, String label, double value) {
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey[700]),
        ),
        const Spacer(),
        Text(
          value < 0
              ? '- ${CurrencyFormatter.format(value.abs())}'
              : CurrencyFormatter.format(value),
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _ConfirmButton extends ConsumerWidget {
  const _ConfirmButton({required this.group, required this.total});

  final DealerCartGroup group;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _checkout(context, ref),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedMotorbike02,
            color: Colors.white,
            size: 20,
          ),
          label: Text(
            'Confirmer les détails de livraison',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  void _checkout(BuildContext context, WidgetRef ref) {
    final result = CheckoutService().checkout([group], {group: total}).first;
    final cartService = ref.read(cartServiceProvider);

    if (result.success) {
      for (final item in group.items) {
        cartService.removeItem(item.productId, item.variationId, item.dealerId);
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          result.success ? 'Commande validée' : 'Provision insuffisante',
        ),
        content: Text(
          result.success
              ? 'Commande de ${CurrencyFormatter.format(total)} confirmée chez ${group.dealer.name}.'
              : '${group.dealer.name} ne peut pas encore couvrir cette commande. Réessayez plus tard.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (result.success && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
