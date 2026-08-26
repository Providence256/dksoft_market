import 'package:flutter/material.dart';

class CartTotalText extends StatelessWidget {
  const CartTotalText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _totalRow(
          context,
          label: 'Subtotal',
          value: 'subtotal',
          labelColor: Colors.grey[600],
          valueStyle: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        _totalRow(
          context,
          label: 'Delivery',
          value: 'deliveryLabel',
          labelColor: Colors.grey[600],
          valueStyle: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1),
        ),
        _totalRow(
          context,
          label: 'Total',
          value: 'subtotal',
          labelStyle: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
          ),
          valueStyle: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _totalRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? labelColor,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: labelColor),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }
}
