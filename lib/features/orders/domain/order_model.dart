import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/exceptions/app_exception.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';

enum OrderStatus { pending, accepted, shipped, delivered, cancelled }

extension OrderStatusString on OrderStatus {
  static OrderStatus fromString(String string) {
    return OrderStatus.values.firstWhere(
      (status) => status.name == string,
      orElse: () => throw ParseOrderFailureException(string),
    );
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'En cours';
      case OrderStatus.accepted:
        return 'Acceptée';
      case OrderStatus.shipped:
        return 'En Livraison';
      case OrderStatus.delivered:
        return 'Terminée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }

  String get trackingDescription {
    switch (this) {
      case OrderStatus.pending:
        return 'Votre commande est en attente de confirmation du dealer.';
      case OrderStatus.accepted:
        return 'Le dealer a accepté votre commande et la prépare.';
      case OrderStatus.shipped:
        return 'Votre commande est en cours de livraison.';
      case OrderStatus.delivered:
        return 'Votre commande a été livrée.';
      case OrderStatus.cancelled:
        return 'Cette commande a été annulée.';
    }
  }

  bool get isCancellable =>
      this == OrderStatus.pending || this == OrderStatus.accepted;

  /// Onglet "En cours" / "Terminés" de l'écran Achats.
  bool get isOngoing =>
      this == OrderStatus.pending ||
      this == OrderStatus.accepted ||
      this == OrderStatus.shipped;
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderStatus,
    required this.orderDate,
    required this.total,
    required this.dealerId,
  });
  final String id;
  final String userId;
  final String dealerId;
  final Map<String, int> items;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final double total;

  int get itemsCount => items.values.fold(0, (sum, qty) => sum + qty);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'dealerId': dealerId,
      'items': items,
      'orderStatus': orderStatus.name,
      'orderDate': orderDate.toIso8601String(),
      'total': total,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final rawOrderDate = map['orderDate'];

    final DateTime orderDate;
    if (rawOrderDate is Timestamp) {
      orderDate = rawOrderDate.toDate();
    } else if (rawOrderDate is String) {
      orderDate = DateTime.tryParse(rawOrderDate) ?? DateTime.now();
    } else {
      orderDate = DateTime.now();
    }

    final rawItems = map['items'];
    final Map<String, int> items = rawItems is Map
        ? rawItems.map(
            (key, value) => MapEntry(key.toString(), (value as num).toInt()),
          )
        : {};

    return OrderModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      dealerId: map['dealerId']?.toString() ?? '',
      items: items,
      orderStatus: OrderStatusString.fromString(
        map['orderStatus']?.toString() ?? 'pending',
      ),
      orderDate: orderDate,
      total: (map['total'] as num?)?.toDouble() ?? 0,
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? dealerId,
    Map<String, int>? items,
    OrderStatus? orderStatus,
    DateTime? orderDate,
    double? total,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dealerId: dealerId ?? this.dealerId,
      items: items ?? this.items,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      total: total ?? this.total,
    );
  }
}

extension OrderItems on OrderModel {
  List<Item> toOrderItems() {
    return items.entries.map((entry) {
      final parts = entry.key.split('|');
      final variationId = (parts.length > 1 && parts[1].isNotEmpty)
          ? parts[1]
          : null;

      return Item(
        productId: parts[0],
        variationId: variationId,
        quantity: entry.value,
      );
    }).toList();
  }
}

String orderItemKey(String productId, String? variationId) =>
    '$productId|${variationId ?? ''}';
