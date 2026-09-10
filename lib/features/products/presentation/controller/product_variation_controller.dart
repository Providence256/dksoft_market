import 'package:dksoft_market/core/domain/dealer_listing.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/dealer/data/fake_dealer_repository.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
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
  final product = ref.watch(watchProductProvider(item.productId)).value;

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
  final basePrice = hasVariations
      ? (selectedVariation?.price ?? product.price)
      : product.price;

  final merchantPrice = product.reduction <= 0
      ? basePrice
      : PricingCalculator.calculateSellingPrice(
          basePrice,
          product.reduction.clamp(0, 100),
        );

  final listings = ref.watch(dealerListingsForProductProvider(item.productId));

  DealerListing? listing;
  for (final l in listings) {
    if (l.dealerId == item.variationId) {
      listing = l;
      break;
    }
  }

  return listing == null ? merchantPrice : listing.prixVente(merchantPrice);
});

/// Même chose que [productPriceProvider] mais SANS la réduction commerçant
/// — le prix "barré" affiché dans le panier (§4.1 : le commerçant peut
/// définir des "conditions particulières" dont une promotion). La
/// différence entre les deux donne la ligne "Remise" du récapitulatif.
final productOriginalPriceProvider = Provider.autoDispose.family<double, Item>((
  ref,
  item,
) {
  final product = ref.watch(watchProductProvider(item.productId)).value;

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
  final basePrice = hasVariations
      ? (selectedVariation?.price ?? product.price)
      : product.price;

  final listings = ref.watch(dealerListingsForProductProvider(item.productId));

  DealerListing? listing;
  for (final l in listings) {
    if (l.dealerId == item.variationId) {
      listing = l;
      break;
    }
  }

  return listing == null ? basePrice : listing.prixVente(basePrice);
});
