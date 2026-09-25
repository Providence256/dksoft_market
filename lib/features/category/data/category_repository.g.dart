// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'a555a942e8b9f9b7d0f559696877ec9d5c6c1f79';

@ProviderFor(categoriesListStream)
final categoriesListStreamProvider = CategoriesListStreamProvider._();

final class CategoriesListStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryModal>>,
          List<CategoryModal>,
          Stream<List<CategoryModal>>
        >
    with
        $FutureModifier<List<CategoryModal>>,
        $StreamProvider<List<CategoryModal>> {
  CategoriesListStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesListStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesListStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<CategoryModal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CategoryModal>> create(Ref ref) {
    return categoriesListStream(ref);
  }
}

String _$categoriesListStreamHash() =>
    r'8f4a8236cbbf348f6ebda253f4b45945e276a7b1';

@ProviderFor(categoryStream)
final categoryStreamProvider = CategoryStreamFamily._();

final class CategoryStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<CategoryModal?>,
          CategoryModal?,
          Stream<CategoryModal?>
        >
    with $FutureModifier<CategoryModal?>, $StreamProvider<CategoryModal?> {
  CategoryStreamProvider._({
    required CategoryStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryStreamHash();

  @override
  String toString() {
    return r'categoryStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<CategoryModal?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CategoryModal?> create(Ref ref) {
    final argument = this.argument as String;
    return categoryStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryStreamHash() => r'99be3ff12cbb2a29d2410890c3e0801c37279281';

final class CategoryStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<CategoryModal?>, String> {
  CategoryStreamFamily._()
    : super(
        retry: null,
        name: r'categoryStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryStreamProvider call(String id) =>
      CategoryStreamProvider._(argument: id, from: this);

  @override
  String toString() => r'categoryStreamProvider';
}

@ProviderFor(categoriesListFuture)
final categoriesListFutureProvider = CategoriesListFutureProvider._();

final class CategoriesListFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryModal>>,
          List<CategoryModal>,
          FutureOr<List<CategoryModal>>
        >
    with
        $FutureModifier<List<CategoryModal>>,
        $FutureProvider<List<CategoryModal>> {
  CategoriesListFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesListFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesListFutureHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryModal>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryModal>> create(Ref ref) {
    return categoriesListFuture(ref);
  }
}

String _$categoriesListFutureHash() =>
    r'f9e6073dd2bbef0ecabd82fab117fc1c536474a4';

@ProviderFor(categoryFuture)
final categoryFutureProvider = CategoryFutureFamily._();

final class CategoryFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<CategoryModal?>,
          CategoryModal?,
          FutureOr<CategoryModal?>
        >
    with $FutureModifier<CategoryModal?>, $FutureProvider<CategoryModal?> {
  CategoryFutureProvider._({
    required CategoryFutureFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryFutureHash();

  @override
  String toString() {
    return r'categoryFutureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CategoryModal?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CategoryModal?> create(Ref ref) {
    final argument = this.argument as String;
    return categoryFuture(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryFutureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryFutureHash() => r'2127c13b9a5285708d3b146b3e02d2afff8c69f7';

final class CategoryFutureFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CategoryModal?>, String> {
  CategoryFutureFamily._()
    : super(
        retry: null,
        name: r'categoryFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryFutureProvider call(String id) =>
      CategoryFutureProvider._(argument: id, from: this);

  @override
  String toString() => r'categoryFutureProvider';
}
