import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/common/fade_slide_in.dart';
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
          ? const SizedBox.shrink()
          : Column(
              spacing: 10,
              children: [
                const HeaderText(text: 'Offres', subtitle: 'Tout voir'),
                CustomHorizontalList(
                  itemCount: products.length,
                  minItemWidth: 180,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * index),
                      offset: const Offset(0.15, 0),
                      child: ProductsCard(product: product),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
