import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CategoryFilterTab extends StatelessWidget {
  const CategoryFilterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: Sizes.p8,
        children: [
          CategoryTab(label: 'Téléphones'),
          CategoryTab(label: 'Modes'),
          CategoryTab(label: 'Ordinateurs'),
          CategoryTab(label: 'Alimentations'),
        ],
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Sizes.p20),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
