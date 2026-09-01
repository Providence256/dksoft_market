import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/features/category/data/category_repository.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFilterTab extends ConsumerWidget {
  const CategoryFilterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryListValue = ref.watch(categoriesListProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AsyncValueWidget(
        value: categoryListValue,
        data: (categories) => categories.isEmpty
            ? Center(child: Text('Categories is empty'))
            : Row(
                spacing: Sizes.p8,
                children: [
                  CategoryTab(label: 'Téléphones'),
                  CategoryTab(label: 'Modes'),
                  CategoryTab(label: 'Ordinateurs'),
                  CategoryTab(label: 'Alimentations'),
                ],
              ),
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
