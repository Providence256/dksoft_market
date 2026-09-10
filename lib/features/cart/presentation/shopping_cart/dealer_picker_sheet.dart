import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A cart can hold items from several dealers, but the cahier des charges
/// (§4.2/§4.3/§6.2) still requires one order per dealer. So instead of
/// grouping the cart visually, we ask the client which dealer to order
/// from right before checkout — the other dealers' items simply stay in
/// the cart for a later order.
Future<void> showDealerPickerSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.p20)),
    ),
    builder: (context) => const DealerPickerSheet(),
  );
}

class DealerPickerSheet extends ConsumerWidget {
  const DealerPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(cartDealerGroupsProvider);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Sizes.p20,
          Sizes.p12,
          Sizes.p20,
          Sizes.p20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(bottom: Sizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              'Choisir le dealer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: Sizes.p4),
            Text(
              "Une commande ne peut regrouper que les articles d'un seul "
              'commerçant. Les autres articles resteront dans votre panier.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.textHintLight),
            ),
            const SizedBox(height: Sizes.p16),
            for (final group in groups) ...[
              _DealerTile(group: group),
              const SizedBox(height: Sizes.p8),
            ],
          ],
        ),
      ),
    );
  }
}

class _DealerTile extends ConsumerWidget {
  const _DealerTile({required this.group});

  final DealerCartGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(dealerGroupTotalProvider(group));

    return Material(
      color: AppColors.cardLight,
      borderRadius: BorderRadius.circular(Sizes.p16),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p16),
        onTap: () {
          Navigator.of(context).pop();
          context.pushNamed(
            AppRoute.checkout.name,
            pathParameters: {'id': group.dealer.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.dealer.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: Sizes.p4),
                    Text(
                      group.totalQuantity > 1
                          ? '${group.totalQuantity} articles'
                          : '${group.totalQuantity} article',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.textHintLight,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(total),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: Sizes.p8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHintLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
