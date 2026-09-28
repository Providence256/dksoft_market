// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartSyncService)
final cartSyncServiceProvider = CartSyncServiceProvider._();

final class CartSyncServiceProvider
    extends
        $FunctionalProvider<CartSyncService, CartSyncService, CartSyncService>
    with $Provider<CartSyncService> {
  CartSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSyncServiceHash();

  @$internal
  @override
  $ProviderElement<CartSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartSyncService create(Ref ref) {
    return cartSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartSyncService>(value),
    );
  }
}

String _$cartSyncServiceHash() => r'cf9f84eba25f9912f92c7064e699c8d977925b15';
