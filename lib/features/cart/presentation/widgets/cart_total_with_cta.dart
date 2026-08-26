import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CartTotalWithCTA extends StatelessWidget {
  const CartTotalWithCTA({super.key, required this.ctaBuilder});
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              '\$2000.00',
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
