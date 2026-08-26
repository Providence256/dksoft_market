import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/features/home/home_screen.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscountWidget extends ConsumerWidget {
  const DiscountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discountProductValue = ref.watch(discountProductProvider);
    return AsyncValueWidget(
      value: discountProductValue,
      data: (products) => products.isEmpty
          ? SizedBox.shrink()
          : Column(
              spacing: 10,
              children: [
                HeaderText(text: 'Offres', subtitle: 'Tout voir'),
                CustomHorizontalList(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductsCard(product: product);
                  },
                ),
              ],
            ),
    );
  }
}
