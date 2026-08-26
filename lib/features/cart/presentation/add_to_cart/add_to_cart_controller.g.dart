// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddToCartController)
final addToCartControllerProvider = AddToCartControllerProvider._();

final class AddToCartControllerProvider
    extends $NotifierProvider<AddToCartController, AsyncValue<int>> {
  AddToCartControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addToCartControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addToCartControllerHash();

  @$internal
  @override
  AddToCartController create() => AddToCartController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<int>>(value),
    );
  }
}

String _$addToCartControllerHash() =>
    r'f917c4813188dc580f4221154264fd6bb74adb5d';

abstract class _$AddToCartController extends $Notifier<AsyncValue<int>> {
  AsyncValue<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, AsyncValue<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, AsyncValue<int>>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
