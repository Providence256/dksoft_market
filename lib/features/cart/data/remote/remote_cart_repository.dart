import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'remote_cart_repository.g.dart';

class RemoteCartRepository {
  RemoteCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<Cart> fetchCart(String uid) async {
    final ref = _cartRef(uid);
    final snapshot = await ref.get();
    return snapshot.data() ?? const Cart();
  }

  Future<void> setCart(String uid, Cart cart) async {
    final ref = _cartRef(uid);

    await ref.set(cart);
  }

  Stream<Cart> watchCart(String uid) {
    final ref = _cartRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data() ?? const Cart());
  }

  DocumentReference<Cart> _cartRef(String uid) => _firestore
      .doc('cart/$uid')
      .withConverter(
        fromFirestore: (doc, _) => Cart.fromMap(doc.data()!),
        toFirestore: (cart, _) => cart.toMap(),
      );
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(Ref ref) {
  return RemoteCartRepository(FirebaseFirestore.instance);
}
