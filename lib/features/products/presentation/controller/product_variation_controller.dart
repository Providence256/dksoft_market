import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
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
