import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/products/data/products_repository.dart';
import 'package:dksoft_market/features/products/domain/product_modal.dart';
import 'package:dksoft_market/features/products/domain/product_variation.dart';
import 'package:dksoft_market/helpers/pricing_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_variation_controller.g.dart';

@riverpod
class ProductVariationController extends _$ProductVariationController {
  @override
  ProductVariation build() {
    return ProductVariation.empty();
  }

  void onAttributeSelected(
    ProductModal product,
    Map<String, String> selectedAttributes,
  ) {
    final selectedVariation = product.variations.firstWhere((variation) {
      return _isSameAttributeValue(
        variation.attributeValues,
        selectedAttributes,
      );
    }, orElse: () => ProductVariation.empty());

    state = selectedVariation;
  }

  bool _isSameAttributeValue(
    Map<String, String> variationAttributes,
    Map<String, String> selectedAttributes,
  ) {
    if (variationAttributes.length != selectedAttributes.length) {
      return false;
    }

    for (final key in variationAttributes.keys) {
      if (variationAttributes[key] != selectedAttributes[key]) {
        return false;
      }
    }

    return true;
  }

  //Get available attribute based on variation and stock
  Set<String?> getAttributesAVailability(
    List<ProductVariation> variations,
    String attributeName,
  ) {
    return variations
        .where(
          (variation) =>
              variation.attributeValues[attributeName] != null &&
              variation.attributeValues[attributeName]!.isNotEmpty &&
              variation.stock > 0,
        )
        .map((variation) => variation.attributeValues[attributeName])
        .toSet();
  }
}

final variationProvider = Provider.autoDispose
    .family<ProductVariation, ProductModal>((ref, product) {
      final selectedVariation = ref.watch(productVariationControllerProvider);

      if (product.variations.isEmpty) {
        return selectedVariation;
      }

      return ProductVariation.empty();
    });

/// Prix final affiché au client pour cette ligne de panier : prix
/// commerçant, réduction éventuelle appliquée, PUIS marge du dealer choisi
/// (`item.dealerId`) ajoutée par-dessus — voir DealerListing.prixVente.
final productPriceProvider = Provider.autoDispose.family<double, Item>((
  ref,
  item,
) {
  final product = ref.watch(productStreamProvider(item.productId)).value;

  final selectedVariation = ref
      .watch(
        productVariationProvider((
          productId: item.productId,
          variationId: item.variationId,
        )),
      )
      .value;

  if (product == null) return 0.0;

  final hasVariations = product.variations.isNotEmpty;
  final basePrice = hasVariations
      ? (selectedVariation?.price ?? product.price)
      : product.price;

  final sellingPrice = product.reduction > 0
      ? PricingCalculator.calculateSellingPrice(basePrice, product.reduction)
      : basePrice;

  return sellingPrice;
});

/// — le prix "barré" affiché dans le panier
final productOriginalPriceProvider = Provider.autoDispose.family<double, Item>((
  ref,
  item,
) {
  final product = ref.watch(productStreamProvider(item.productId)).value;

  if (product == null) return 0.0;

  final selectedVariation = ref
      .watch(
        productVariationProvider((
          productId: item.productId,
          variationId: item.variationId,
        )),
      )
      .value;

  final hasVariations = product.variations.isNotEmpty;
  return hasVariations
      ? (selectedVariation?.price ?? product.price)
      : product.price;
});
