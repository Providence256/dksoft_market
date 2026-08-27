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
    final rawItems = map['items'] as Map? ?? const {};

    final items = rawItems.map<String, int>(
      (key, value) => MapEntry(key as String, (value as num).toInt()),
    );

    return Cart(items);
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
  /// Converts the raw `productId[|variationId] -> quantity` map into a list
  /// of [Item]s.
  ///
  /// Products without variations are stored under a plain `productId` key
  /// (see [MutableCart._generatekey]), so `variationId` is only present when
  /// there is a second `|`-separated part.
  List<Item> toItemList() {
    return items.entries.map((entry) {
      final keyParts = entry.key.split('|');
      final productId = keyParts[0];
      final variationId = keyParts.length > 1 ? keyParts[1] : null;

      return Item(
        productId: productId,
        quantity: entry.value,
        variationId: variationId,
      );
    }).toList();
  }
}
