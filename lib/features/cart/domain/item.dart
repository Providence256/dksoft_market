// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Une ligne de panier.
///
/// [dealerId] est obligatoire : dans ce marketplace, un client ne commande
/// jamais un produit directement — il commande TOUJOURS via un dealer
/// (cahier des charges §3.1, §4.3). Comme un même produit peut être proposé
/// par plusieurs dealers à des prix différents, le dealer fait partie de
/// l'identité de la ligne de panier, pas juste le produit.
class Item {
  Item({
    required this.productId,
    required this.quantity,
    required this.dealerId,
    this.variationId,
  });

  final String productId;
  final int quantity;
  final String dealerId;
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
      dealerId: dealerId ?? this.dealerId,
      variationId: variationId ?? this.variationId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'dealerId': dealerId,
      'variationId': variationId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      dealerId: map['dealerId'] as String,
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
      'dealerId: $dealerId, variationId: $variationId)';

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.quantity == quantity &&
        other.dealerId == dealerId &&
        other.variationId == variationId;
  }

  @override
  int get hashCode =>
      productId.hashCode ^
      quantity.hashCode ^
      dealerId.hashCode ^
      variationId.hashCode;
}
