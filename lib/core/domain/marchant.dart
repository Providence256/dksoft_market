import 'dart:convert';

class Merchant {
  const Merchant({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.rating,
    required this.salesCount,
    required this.verified,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final double rating;
  final int salesCount;
  final bool verified;

  /// Fallback used when a product references a `marchandId` that has no
  /// matching merchant record, so the UI always has something safe to show
  /// instead of crashing.
  factory Merchant.unknown(String id) => Merchant(
    id: id,
    name: 'Vendeur',
    rating: 0,
    salesCount: 0,
    verified: false,
  );

  Merchant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? rating,
    int? salesCount,
    bool? verified,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'salesCount': salesCount,
      'verified': verified,
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      rating: (map['rating'] as num).toDouble(),
      salesCount: (map['salesCount'] as num).toInt(),
      verified: map['verified'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Merchant(id: $id, name: $name, rating: $rating, '
      'salesCount: $salesCount, verified: $verified)';

  @override
  bool operator ==(covariant Merchant other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.rating == rating &&
        other.salesCount == salesCount &&
        other.verified == verified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatarUrl.hashCode ^
        rating.hashCode ^
        salesCount.hashCode ^
        verified.hashCode;
  }
}
