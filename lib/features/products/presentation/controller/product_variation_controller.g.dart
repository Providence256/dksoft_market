// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductVariationController)
final productVariationControllerProvider =
    ProductVariationControllerProvider._();

final class ProductVariationControllerProvider
    extends $NotifierProvider<ProductVariationController, ProductVariation> {
  ProductVariationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productVariationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productVariationControllerHash();

  @$internal
  @override
  ProductVariationController create() => ProductVariationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductVariation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductVariation>(value),
    );
  }
}

String _$productVariationControllerHash() =>
    r'c354568c1297f71f00ea0b25e1bb7f59cfeb88da';

abstract class _$ProductVariationController
    extends $Notifier<ProductVariation> {
  ProductVariation build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProductVariation, ProductVariation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductVariation, ProductVariation>,
              ProductVariation,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
