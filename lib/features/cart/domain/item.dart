// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  Item({required this.productId, required this.quantity, this.variationId});

  final String productId;
  final int quantity;
  final String? variationId;

  Item copyWith({
    String? productId,
    int? quantity,
    String? dealerId,
    String? variationId,
  }) {
    return Item(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      variationId: variationId ?? this.variationId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'variationId': variationId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      variationId: map['variationId'] != null
          ? map['variationId'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Item(productId: $productId, quantity: $quantity, '
      ' variationId: $variationId)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.quantity == quantity &&
        other.variationId == variationId;
  }

  @override
  int get hashCode =>
      productId.hashCode ^ quantity.hashCode ^ variationId.hashCode;
}
