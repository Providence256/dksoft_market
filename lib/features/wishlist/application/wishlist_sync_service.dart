import 'package:dksoft_market/exceptions/error_logger.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/authentication/domain/app_user.dart';
import 'package:dksoft_market/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_sync_service.g.dart';

class WishlistSyncService {
  WishlistSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (
      previous,
      next,
    ) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteWishlist(user.uid);
      }
    });
  }

  Future<void> _moveItemsToRemoteWishlist(String uid) async {
    try {
      final localRepository = ref.read(localWishlistRepositoryProvider);
      final localWishlist = await localRepository.fetchWishlist();

      if (localWishlist.items.isEmpty) return;

      final remoteRepository = ref.read(remoteWishlistRepositoryProvider);
      final remoteWishlist = await remoteRepository.fetchWishlist(uid);

      final merged = {...remoteWishlist.items, ...localWishlist.items}.toList();

      await remoteRepository.setWishlist(uid, Wishlist(merged));

      await localRepository.setWishlist(Wishlist());
    } catch (e, st) {
      ref.read(errorLoggerProvider).logError(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
WishlistSyncService wishlistSyncService(Ref ref) {
  return WishlistSyncService(ref);
}
