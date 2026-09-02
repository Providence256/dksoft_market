import 'package:dksoft_market/features/wishlist/data/remote/remote_wishlist_repository_impl.dart';
import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteWishlistRepository {
  Future<Wishlist> fetchWishlist(String uid);
  Stream<Wishlist> watchWishlist(String uid);
  Future<void> setWishlist(String uid, Wishlist wishlist);
}

final remoteWishlistRepositoryProvider = Provider<RemoteWishlistRepository>((
  ref,
) {
  return RemoteWishlistRepositoryImpl();
});
