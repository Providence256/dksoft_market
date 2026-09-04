import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';

class BillRow extends StatelessWidget {
  const BillRow({super.key, required this.label, this.value, this.valueText});

  final String label;
  final double? value;
  final String? valueText;

  @override
  Widget build(BuildContext context) {
    final text =
        valueText ??
        (value! < 0
            ? '- ${CurrencyFormatter.format(value!.abs())}'
            : CurrencyFormatter.format(value!));
    final isFree = valueText == 'Gratuit';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: isFree ? AppColors.primary : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
