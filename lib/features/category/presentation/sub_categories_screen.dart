import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/features/category/data/category_repository.dart';
import 'package:dksoft_market/features/category/domain/sub_category.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubCategoriesScreen extends ConsumerWidget {
  const SubCategoriesScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryValue = ref.watch(categoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryValue.value?.name ?? 'Sous categories',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: AsyncValueWidget(
        value: categoryValue,
        data: (category) {
          if (category == null) {
            return const Center(child: Text('Categorie introuvable'));
          }

          final subCategories = category.subCategory;

          return subCategories.isEmpty
              ? const Center(child: Text('Aucune sous categorie'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                  itemCount: subCategories.length,
                  separatorBuilder: (_, __) => CustomDivider(),
                  itemBuilder: (context, index) {
                    final subCategory = subCategories[index];
                    return _SubCategoryTile(
                      categoryId: categoryId,
                      subCategory: subCategory,
                    );
                  },
                );
        },
      ),
    );
  }
}

class _SubCategoryTile extends StatelessWidget {
  const _SubCategoryTile({required this.categoryId, required this.subCategory});

  final String categoryId;
  final SubCategory subCategory;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardLight.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(Sizes.p16),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p16),
        onTap: () => context.goNamed(
          AppRoute.subCategoryProducts.name,
          pathParameters: {
            'categoryId': categoryId,
            'subCategoryId': subCategory.id,
          },
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  subCategory.name,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHintLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
