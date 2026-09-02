import 'package:dksoft_market/features/wishlist/application/wishlist_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class WishlistController extends StateNotifier<AsyncValue<void>> {
  WishlistController({required this.wishlistService})
    : super(const AsyncValue.data(null));

  final WishlistService wishlistService;

  Future<void> toggleItem(String listingId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => wishlistService.setItem(listingId));
  }
}

final wishlistControllerProvider =
    StateNotifierProvider<WishlistController, AsyncValue<void>>((ref) {
      return WishlistController(
        wishlistService: ref.watch(wishlistServiceProvider),
      );
    });

final isInWishlistProvider = Provider.family<bool, String>((ref, listingId) {
  final wishlist = ref.watch(wishlistProvider);

  return wishlist.maybeWhen(
    data: (data) => data.items.contains(listingId),
    orElse: () => false,
  );
});
