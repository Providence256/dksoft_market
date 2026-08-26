// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:flutter/foundation.dart';

class Cart {
  const Cart([this.items = const {}]);

  final Map<String, int> items;

  Cart copyWith({Map<String, int>? items}) {
    return Cart(items ?? this.items);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'items': items};
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(Map<String, int>.from((map['items'] as Map<String, int>)));
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(items: $items)';

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension CartItems on Cart {
  List<Item> toItemList() {
    return items.entries.map((entry) {
      final keyParts = entry.key.split('|');
      final productId = keyParts[0];
      final variationId = keyParts[1];

      return Item(
        productId: productId,
        quantity: entry.value,
        variationId: variationId,
      );
    }).toList();
  }
}
