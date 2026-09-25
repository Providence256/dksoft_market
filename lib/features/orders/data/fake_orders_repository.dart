import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/orders/domain/order_model.dart';
import 'package:dksoft_market/utils/validators/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeOrdersRepository {
  final _orders = InMemoryStore<Map<String, List<OrderModel>>>({});

  // Stream that return all the orders for a given user, ordered by date
  Stream<List<OrderModel>> watchUserOrders(String uid) {
    return _orders.stream.map((ordersData) {
      final orderList = ordersData[uid] ?? [];

      orderList.sort((lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate));

      return orderList;
    });
  }

  //Method to add a new order to the list for a given user
  Future<void> addOrder(String uid, OrderModel order) async {
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    userOrders.add(order);
    value[uid] = userOrders;
    _orders.value = value;
  }

  Stream<OrderModel?> watchUserOrder(String uid, String orderId) {
    return watchUserOrders(uid).map((orders) => _getOrder(orders, orderId));
  }

  Future<void> updateOrderStatus(
    String uid,
    String orderId,
    OrderStatus status,
  ) async {
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    final index = userOrders.indexWhere((order) => order.id == orderId);

    if (index == -1) return;

    userOrders[index] = userOrders[index].copyWith(orderStatus: status);
    value[uid] = userOrders;
    _orders.value = value;
  }

  static OrderModel? _getOrder(List<OrderModel> orders, String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}

final ordersRepositoryProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});

final userOrdersProvider = StreamProvider.autoDispose<List<OrderModel>>((ref) {
  final repository = ref.watch(ordersRepositoryProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;

  if (user == null) return const Stream.empty();

  return repository.watchUserOrders(user.uid);
});

final orderProvider = StreamProvider.autoDispose.family<OrderModel?, String>((
  ref,
  id,
) {
  final repository = ref.watch(ordersRepositoryProvider);
  final user = ref.watch(authRepositoryProvider).currentUser!;

  return repository.watchUserOrder(user.uid, id);
});
