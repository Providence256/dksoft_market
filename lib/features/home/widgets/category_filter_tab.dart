import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/features/category/data/category_repository.dart';
import 'package:dksoft_market/features/category/domain/category_modal.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryFilterTab extends ConsumerWidget {
  const CategoryFilterTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryListValue = ref.watch(categoriesListProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: AsyncValueWidget(
        value: categoryListValue,
        data: (categories) => categories.isEmpty
            ? const Center(child: Text('Categories is empty'))
            : Row(
                spacing: Sizes.p12,
                children: [
                  for (final category in categories)
                    CategoryTab(category: category),
                ],
              ),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  final CategoryModal category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => context.goNamed(
            AppRoute.subCategories.name,
            pathParameters: {'categoryId': category.id},
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.dividerLight,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image(
              image: AssetImage(category.imageUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 68,
          child: Text(
            category.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
