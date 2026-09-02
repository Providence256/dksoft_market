// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Wishlist {
  final List<String> items;

  Wishlist([this.items = const []]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'items': items};
  }

  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(List<String>.from(map['items'] ?? []));
  }

  String toJson() => json.encode(toMap());

  factory Wishlist.fromJson(String source) =>
      Wishlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Wishlist(items: $items)';

  @override
  bool operator ==(covariant Wishlist other) {
    if (identical(this, other)) return true;

    return listEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension WishlistItems on Wishlist {
  List<String> toItemsList() {
    return items.map((id) {
      return id;
    }).toList();
  }
}
