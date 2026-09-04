import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class TipChip extends StatelessWidget {
  const TipChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.p20 + 6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p20,
          vertical: Sizes.p12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.cardLight.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(Sizes.p20 + 6),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: selected ? Colors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
