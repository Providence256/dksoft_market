import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/features/category/data/category_repository.dart';
import 'package:dksoft_market/features/category/domain/category_modal.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesValue = ref.watch(categoriesListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: AsyncValueWidget(
        value: categoriesValue,
        data: (categories) => categories.isEmpty
            ? const Center(child: Text('Aucune categorie'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const CustomDivider(),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryTile(category: category);
                },
              ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final CategoryModal category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardLight.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(Sizes.p16),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p16),
        onTap: () => context.goNamed(
          AppRoute.subCategories.name,
          pathParameters: {'categoryId': category.id},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.p8,
            horizontal: Sizes.p12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
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
