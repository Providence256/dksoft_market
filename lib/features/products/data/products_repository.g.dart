// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productsRepository)
final productsRepositoryProvider = ProductsRepositoryProvider._();

final class ProductsRepositoryProvider
    extends
        $FunctionalProvider<
          ProductsRepository,
          ProductsRepository,
          ProductsRepository
        >
    with $Provider<ProductsRepository> {
  ProductsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductsRepository create(Ref ref) {
    return productsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductsRepository>(value),
    );
  }
}

String _$productsRepositoryHash() =>
    r'6bb9aac84882ffe94981da5617a35df0343457a6';

@ProviderFor(productsListStream)
final productsListStreamProvider = ProductsListStreamProvider._();

final class ProductsListStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModal>>,
          List<ProductModal>,
          Stream<List<ProductModal>>
        >
    with
        $FutureModifier<List<ProductModal>>,
        $StreamProvider<List<ProductModal>> {
  ProductsListStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsListStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsListStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ProductModal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModal>> create(Ref ref) {
    return productsListStream(ref);
  }
}

String _$productsListStreamHash() =>
    r'e9650ec20882c64b7280a5f46a9803c976f0f22f';

@ProviderFor(productsDiscountStream)
final productsDiscountStreamProvider = ProductsDiscountStreamProvider._();

final class ProductsDiscountStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModal>>,
          List<ProductModal>,
          Stream<List<ProductModal>>
        >
    with
        $FutureModifier<List<ProductModal>>,
        $StreamProvider<List<ProductModal>> {
  ProductsDiscountStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsDiscountStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsDiscountStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ProductModal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModal>> create(Ref ref) {
    return productsDiscountStream(ref);
  }
}

String _$productsDiscountStreamHash() =>
    r'b63d1417745100ee104a55ca5a074f31bab6b650';

@ProviderFor(productsListFuture)
final productsListFutureProvider = ProductsListFutureProvider._();

final class ProductsListFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModal>>,
          List<ProductModal>,
          FutureOr<List<ProductModal>>
        >
    with
        $FutureModifier<List<ProductModal>>,
        $FutureProvider<List<ProductModal>> {
  ProductsListFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsListFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsListFutureHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductModal>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductModal>> create(Ref ref) {
    return productsListFuture(ref);
  }
}

String _$productsListFutureHash() =>
    r'10cd81e1211c3a438d24f6e8cdc03b39b993a3b2';

@ProviderFor(productStream)
final productStreamProvider = ProductStreamFamily._();

final class ProductStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductModal?>,
          ProductModal?,
          Stream<ProductModal?>
        >
    with $FutureModifier<ProductModal?>, $StreamProvider<ProductModal?> {
  ProductStreamProvider._({
    required ProductStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productStreamHash();

  @override
  String toString() {
    return r'productStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ProductModal?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ProductModal?> create(Ref ref) {
    final argument = this.argument as String;
    return productStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productStreamHash() => r'0c8db08cbf19c9b16d92112a048f64789a37e7a5';

final class ProductStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ProductModal?>, String> {
  ProductStreamFamily._()
    : super(
        retry: null,
        name: r'productStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductStreamProvider call(String id) =>
      ProductStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'productStreamProvider';
}

@ProviderFor(productsBySubCateStream)
final productsBySubCateStreamProvider = ProductsBySubCateStreamFamily._();

final class ProductsBySubCateStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductModal>>,
          List<ProductModal>,
          Stream<List<ProductModal>>
        >
    with
        $FutureModifier<List<ProductModal>>,
        $StreamProvider<List<ProductModal>> {
  ProductsBySubCateStreamProvider._({
    required ProductsBySubCateStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsBySubCateStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsBySubCateStreamHash();

  @override
  String toString() {
    return r'productsBySubCateStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ProductModal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProductModal>> create(Ref ref) {
    final argument = this.argument as String;
    return productsBySubCateStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsBySubCateStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsBySubCateStreamHash() =>
    r'a44e41d971def620e21ddf2233ee95823527e72c';

final class ProductsBySubCateStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ProductModal>>, String> {
  ProductsBySubCateStreamFamily._()
    : super(
        retry: null,
        name: r'productsBySubCateStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsBySubCateStreamProvider call(String subCategoryId) =>
      ProductsBySubCateStreamProvider._(argument: subCategoryId, from: this);

  @override
  String toString() => r'productsBySubCateStreamProvider';
}

@ProviderFor(productFuture)
final productFutureProvider = ProductFutureFamily._();

final class ProductFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductModal?>,
          ProductModal?,
          FutureOr<ProductModal?>
        >
    with $FutureModifier<ProductModal?>, $FutureProvider<ProductModal?> {
  ProductFutureProvider._({
    required ProductFutureFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productFutureHash();

  @override
  String toString() {
    return r'productFutureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductModal?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductModal?> create(Ref ref) {
    final argument = this.argument as String;
    return productFuture(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productFutureHash() => r'fc41d3bb43a6cc1425a4043bcac32969def1d5c6';

final class ProductFutureFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductModal?>, String> {
  ProductFutureFamily._()
    : super(
        retry: null,
        name: r'productFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductFutureProvider call(String id) =>
      ProductFutureProvider._(argument: id, from: this);

  @override
  String toString() => r'productFutureProvider';
}

@ProviderFor(productVariation)
final productVariationProvider = ProductVariationFamily._();

final class ProductVariationProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductVariation?>,
          ProductVariation?,
          FutureOr<ProductVariation?>
        >
    with
        $FutureModifier<ProductVariation?>,
        $FutureProvider<ProductVariation?> {
  ProductVariationProvider._({
    required ProductVariationFamily super.from,
    required ProductVariationKey super.argument,
  }) : super(
         retry: null,
         name: r'productVariationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productVariationHash();

  @override
  String toString() {
    return r'productVariationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductVariation?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductVariation?> create(Ref ref) {
    final argument = this.argument as ProductVariationKey;
    return productVariation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductVariationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productVariationHash() => r'fb6a60d1f6b72f1f1cea509de333681724c47272';

final class ProductVariationFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ProductVariation?>,
          ProductVariationKey
        > {
  ProductVariationFamily._()
    : super(
        retry: null,
        name: r'productVariationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductVariationProvider call(ProductVariationKey key) =>
      ProductVariationProvider._(argument: key, from: this);

  @override
  String toString() => r'productVariationProvider';
}
