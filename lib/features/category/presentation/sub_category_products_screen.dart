import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/features/category/data/category_repository.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_card.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubCategoryProductsScreen extends ConsumerWidget {
  const SubCategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
  });

  final String categoryId;
  final String subCategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryValue = ref.watch(categoryProvider(categoryId));
    final productsValue = ref.watch(
      productsBySubCategoryProvider(subCategoryId),
    );

    String? subCategoryName;
    final subCategories = categoryValue.value?.subCategory;
    if (subCategories != null) {
      for (final sub in subCategories) {
        if (sub.id == subCategoryId) {
          subCategoryName = sub.name;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          subCategoryName ?? 'Produits',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: AsyncValueWidget(
          value: productsValue,
          data: (products) => products.isEmpty
              ? const Center(child: Text('Aucun produit dans cette categorie'))
              : SingleChildScrollView(
                  child: CustomLayoutGrid(
                    itemCount: products.length,
                    itemBuilder: (_, index) =>
                        ProductsCard(product: products[index]),
                  ),
                ),
        ),
      ),
    );
  }
}
