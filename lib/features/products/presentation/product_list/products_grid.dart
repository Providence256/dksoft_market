import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsListValue = ref.watch(watchproductsProvider);
    return AsyncValueWidget(
      value: productsListValue,
      data: (products) => products.isEmpty
          ? Center(child: Text('No Products Found'))
          : CustomLayoutGrid(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return ProductsCard(product: product);
              },
            ),
    );
  }
}
