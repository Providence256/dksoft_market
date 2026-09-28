// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_cart_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteCartRepository)
final remoteCartRepositoryProvider = RemoteCartRepositoryProvider._();

final class RemoteCartRepositoryProvider
    extends
        $FunctionalProvider<
          RemoteCartRepository,
          RemoteCartRepository,
          RemoteCartRepository
        >
    with $Provider<RemoteCartRepository> {
  RemoteCartRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteCartRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteCartRepositoryHash();

  @$internal
  @override
  $ProviderElement<RemoteCartRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoteCartRepository create(Ref ref) {
    return remoteCartRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteCartRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteCartRepository>(value),
    );
  }
}

String _$remoteCartRepositoryHash() =>
    r'7692db975fdd8e6ea509aaf8df0e756cd1c09754';
