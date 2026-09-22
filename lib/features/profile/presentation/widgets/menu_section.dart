import 'package:dksoft_market/features/profile/presentation/widgets/menu_tile.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class MenuItemData {
  const MenuItemData({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
}

class MenuSection extends StatelessWidget {
  const MenuSection({super.key, required this.title, required this.items});

  final String title;
  final List<MenuItemData> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Sizes.p4, bottom: Sizes.p8),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: AppColors.textHintLight),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(Sizes.p16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: Sizes.p16 + 40 + Sizes.p12,
                      color: AppColors.dividerLight,
                    ),
                  MenuTile(item: items[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
