import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cardLight.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: HugeIcon(
              icon: icon,
              size: 20,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
        const SizedBox(width: Sizes.p12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: Sizes.p4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.textHintLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(
            Icons.edit_outlined,
            color: AppColors.primary,
            size: 18,
          ),
        ),
      ],
    );
  }
}
