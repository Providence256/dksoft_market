import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/helpers/pricing_calculator.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Prix de l'article affiché sur la page produit : celui de la variation
/// sélectionnée si le client en a choisi une, sinon le prix de base du
/// produit — jamais une fourchette min/max entre toutes les variations.
class ProductPrice extends ConsumerWidget {
  const ProductPrice({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVariation = ref.watch(selectedVariationProvider);

    final basePrice = selectedVariation.id.isNotEmpty
        ? selectedVariation.price
        : product.price;

    final sellingPrice = product.reduction > 0
        ? PricingCalculator.calculateSellingPrice(basePrice, product.reduction)
        : basePrice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          CurrencyFormatter.format(sellingPrice),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (product.reduction > 0) ...[
          const SizedBox(width: 10),
          Text(
            CurrencyFormatter.format(basePrice),
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
