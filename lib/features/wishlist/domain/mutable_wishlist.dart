import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';

extension MutableWishlist on Wishlist {
  Wishlist toggleItem(String listingId) {
    final copy = List<String>.from(items);

    if (copy.contains(listingId)) {
      copy.remove(listingId);
    } else {
      copy.add(listingId);
    }

    return Wishlist(copy);
  }
}
