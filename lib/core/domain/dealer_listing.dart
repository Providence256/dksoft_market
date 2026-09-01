// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Une "offre" : un produit qu'un [Dealer] a choisi de proposer parmi le
/// catalogue des commerçants (§5.4 : "Sélection des produits à proposer").
///
/// Le commerçant reste propriétaire du produit (stock, prix de base) ; le
/// dealer ajoute sa marge par-dessus. Plusieurs dealers peuvent avoir une
/// [DealerListing] pour le même `productId`, chacun avec sa propre marge —
/// c'est ce qui permet à un produit d'être "proposé par 4 dealers".
class DealerListing {
  const DealerListing({
    required this.dealerId,
    required this.productId,
    required this.margePourcentage,
    this.actif = true,
  });

  final String dealerId;
  final String productId;

  /// Marge du dealer en % ajoutée au prix commerçant, ex. 8 => +8%.
  final double margePourcentage;

  final bool actif;

  /// Prix final affiché au client pour cette offre.
  double prixVente(double prixCommercant) {
    return prixCommercant * (1 + margePourcentage / 100);
  }

  /// Ce que le dealer gagne sur une vente à ce prix.
  double margeSur(double prixCommercant) {
    return prixVente(prixCommercant) - prixCommercant;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dealerId': dealerId,
      'productId': productId,
      'margePourcentage': margePourcentage,
      'actif': actif,
    };
  }

  factory DealerListing.fromMap(Map<String, dynamic> map) {
    return DealerListing(
      dealerId: map['dealerId'] as String,
      productId: map['productId'] as String,
      margePourcentage: (map['margePourcentage'] as num).toDouble(),
      actif: map['actif'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerListing.fromJson(String source) =>
      DealerListing.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DealerListing(dealerId: $dealerId, productId: $productId, '
      'marge: $margePourcentage%)';

  @override
  bool operator ==(covariant DealerListing other) {
    if (identical(this, other)) return true;
    return other.dealerId == dealerId &&
        other.productId == productId &&
        other.margePourcentage == margePourcentage &&
        other.actif == actif;
  }

  @override
  int get hashCode =>
      dealerId.hashCode ^
      productId.hashCode ^
      margePourcentage.hashCode ^
      actif.hashCode;
}
