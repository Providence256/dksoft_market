import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/orders/domain/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Writes orders to the shared `orders` Firestore collection so the dealer
/// app (same Firebase project) sees them in real time. This is separate
/// from [FakeOrdersRepository], which still powers the client's own
/// "Mes achats" screen locally.
class FirestoreOrdersRepository {
  FirestoreOrdersRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Stream<List<OrderModel>> watchUserOrders(String uid) {
    return _orders
        .where('userId', isEqualTo: uid)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return OrderModel.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }

  Stream<OrderModel?> watchUserOrder(String uid, String orderId) {
    return watchUserOrders(uid).map((orders) => _getOrder(orders, orderId));
  }

  Future<void> updateOrderStatus(
    String uid,
    String orderId,
    OrderStatus status,
  ) async {
    await _firestore.collection('orders').doc(orderId).update({
      'orderStatus': status.name,
    });
  }

  Future<void> addOrder(OrderModel order) {
    return _firestore.collection('orders').doc(order.id).set(order.toMap());
  }

  static OrderModel? _getOrder(List<OrderModel> orders, String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}

final firestoreOrdersRepositoryProvider = Provider<FirestoreOrdersRepository>(
  (ref) => FirestoreOrdersRepository(FirebaseFirestore.instance),
);

final userOrdersProvider = StreamProvider.autoDispose<List<OrderModel>>((ref) {
  final repository = ref.watch(firestoreOrdersRepositoryProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;

  if (user == null) return const Stream.empty();

  return repository.watchUserOrders(user.uid);
});

final orderProvider = StreamProvider.autoDispose.family<OrderModel?, String>((
  ref,
  id,
) {
  final repository = ref.watch(firestoreOrdersRepositoryProvider);
  final user = ref.watch(authRepositoryProvider).currentUser!;

  return repository.watchUserOrder(user.uid, id);
});
