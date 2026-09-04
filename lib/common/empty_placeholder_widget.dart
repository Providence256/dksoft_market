import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final String title;
  final String subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Sizes.p20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: Sizes.p48,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: Sizes.p16),
          Text(
            'Aucun panier pour le moment',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Les articles que vous ajoutez apparaîtront ici,\ngroupés par dealer.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
