import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartTotalWithCTA extends ConsumerWidget {
  const CartTotalWithCTA({super.key, required this.ctaBuilder});
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartTotal = ref.watch(cartTotalProvider);

    return Row(
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
            Text(
              '$cartTotal',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(child: ctaBuilder(context)),
      ],
    );
  }
}
