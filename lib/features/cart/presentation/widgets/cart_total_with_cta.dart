import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartTotalWithCTA extends ConsumerWidget {
  const CartTotalWithCTA({super.key, required this.ctaBuilder});
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subtotal = ref.watch(cartSubtotalProvider);
    final itemCount = ref.watch(cartItemsCountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemCount > 1 ? '$itemCount articles' : '$itemCount article',
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.grey[600],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                CurrencyFormatter.format(subtotal),
                key: ValueKey(subtotal),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    CurrencyFormatter.format(subtotal),
                    key: ValueKey('total_$subtotal'),
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(child: ctaBuilder(context)),
          ],
        ),
      ],
    );
  }
}
