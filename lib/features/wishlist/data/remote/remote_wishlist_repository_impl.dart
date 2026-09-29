import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';

class RemoteWishlistRepositoryImpl implements RemoteWishlistRepository {
  RemoteWishlistRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<Wishlist> fetchWishlist(String uid) async {
    final snapshot = await _wishlistRef(uid).get();
    return snapshot.data() ?? Wishlist();
  }

  @override
  Future<void> setWishlist(String uid, Wishlist wishlist) {
    return _wishlistRef(uid).set(wishlist);
  }

  @override
  Stream<Wishlist> watchWishlist(String uid) {
    return _wishlistRef(
      uid,
    ).snapshots().map((snapshot) => snapshot.data() ?? Wishlist());
  }

  DocumentReference<Wishlist> _wishlistRef(String uid) => _firestore
      .doc('wishlist/$uid')
      .withConverter<Wishlist>(
        fromFirestore: (doc, _) => Wishlist.fromMap(doc.data()!),
        toFirestore: (wishlist, _) => wishlist.toMap(),
      );
}
