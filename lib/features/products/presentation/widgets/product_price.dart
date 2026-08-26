import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductPrice extends ConsumerWidget {
  const ProductPrice({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellingPrice = PricingCalculator.getSellingPrice(product);
    final formatedPrice = PricingCalculator.getProoductprice(product);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(sellingPrice, style: Theme.of(context).textTheme.headlineMedium),
        if (product.reduction != 0) ...[
          const SizedBox(width: 10),
          Text(
            formatedPrice,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          ReductionContainer(percentage: product.reduction),
        ],
      ],
    );
  }
}
