// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wishlistSyncService)
final wishlistSyncServiceProvider = WishlistSyncServiceProvider._();

final class WishlistSyncServiceProvider
    extends
        $FunctionalProvider<
          WishlistSyncService,
          WishlistSyncService,
          WishlistSyncService
        >
    with $Provider<WishlistSyncService> {
  WishlistSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistSyncServiceHash();

  @$internal
  @override
  $ProviderElement<WishlistSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WishlistSyncService create(Ref ref) {
    return wishlistSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WishlistSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WishlistSyncService>(value),
    );
  }
}

String _$wishlistSyncServiceHash() =>
    r'eff628b56a03a68e110bb5e28abb4536eaa0e781';
