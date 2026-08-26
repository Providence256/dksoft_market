import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProductVariationController extends StateNotifier<ProductVariation> {
  ProductVariationController() : super(ProductVariation.empty());

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
    if (variationAttributes.length != selectedAttributes.length) return false;

    for (final key in variationAttributes.keys) {
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  //Get available attribute based on variation and stock
  Set<String?> getAttributesAvailability(
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

final selectedAttributesProvider =
    StateProvider.autoDispose<Map<String, String>>((ref) {
      return {};
    });

final selectedVariationProvider =
    StateNotifierProvider.autoDispose<
      ProductVariationController,
      ProductVariation
    >((ref) {
      return ProductVariationController();
    });
