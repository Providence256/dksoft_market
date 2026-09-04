import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

enum DeliveryMode { home, pickup }

class DeliveryModeToggle extends StatelessWidget {
  const DeliveryModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final DeliveryMode mode;
  final ValueChanged<DeliveryMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(Sizes.p20 + 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              label: 'Livraison à domicile',
              selected: mode == DeliveryMode.home,
              onTap: () => onChanged(DeliveryMode.home),
            ),
          ),
          Expanded(
            child: _ToggleOption(
              label: 'À emporter',
              selected: mode == DeliveryMode.pickup,
              onTap: () => onChanged(DeliveryMode.pickup),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
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
      borderRadius: BorderRadius.circular(Sizes.p20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(Sizes.p20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: selected ? Colors.white : AppColors.textHintLight,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
