// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Statut de validation d'un dealer par l'administration (voir §5.9 / §6.2
/// du cahier des charges : "Le dealer doit être validé par l'administration").
enum DealerStatus { enAttente, valide, suspendu, refuse }

/// Un dealer : intermédiaire entre le client et les produits des
/// commerçants. Doit disposer d'une provision suffisante pour valider une
/// commande (§4.2, §5.5 du cahier des charges).
class Dealer {
  const Dealer({
    required this.id,
    required this.name,
    required this.phone,
    required this.zone,
    required this.provisionDisponible,
    this.provisionBloquee = 0,
    this.commissionParDefaut = 10,
    this.status = DealerStatus.valide,
    this.rating = 0,
    this.commandesTraitees = 0,
  });

  final String id;
  final String name;
  final String phone;

  /// Commune d'activité principale à Kinshasa (§8).
  final String zone;

  /// Solde que le dealer peut utiliser pour couvrir de nouvelles commandes.
  final double provisionDisponible;

  /// Montant déjà réservé pour des commandes en cours de traitement.
  final double provisionBloquee;

  /// Marge/commission par défaut (%) appliquée sur le prix commerçant quand
  /// une [DealerListing] ne définit pas sa propre marge.
  final double commissionParDefaut;

  final DealerStatus status;
  final double rating;
  final int commandesTraitees;

  double get provisionTotale => provisionDisponible + provisionBloquee;

  bool get estValide => status == DealerStatus.valide;

  /// Règle centrale du cahier des charges (§4.2, §6.2) : un dealer ne peut
  /// traiter une commande que si sa provision disponible couvre le montant.
  bool peutCouvrir(double montant) => estValide && provisionDisponible >= montant;

  Dealer copyWith({
    String? id,
    String? name,
    String? phone,
    String? zone,
    double? provisionDisponible,
    double? provisionBloquee,
    double? commissionParDefaut,
    DealerStatus? status,
    double? rating,
    int? commandesTraitees,
  }) {
    return Dealer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      zone: zone ?? this.zone,
      provisionDisponible: provisionDisponible ?? this.provisionDisponible,
      provisionBloquee: provisionBloquee ?? this.provisionBloquee,
      commissionParDefaut: commissionParDefaut ?? this.commissionParDefaut,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      commandesTraitees: commandesTraitees ?? this.commandesTraitees,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'zone': zone,
      'provisionDisponible': provisionDisponible,
      'provisionBloquee': provisionBloquee,
      'commissionParDefaut': commissionParDefaut,
      'status': status.name,
      'rating': rating,
      'commandesTraitees': commandesTraitees,
    };
  }

  factory Dealer.fromMap(Map<String, dynamic> map) {
    return Dealer(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      zone: map['zone'] as String,
      provisionDisponible: (map['provisionDisponible'] as num).toDouble(),
      provisionBloquee: (map['provisionBloquee'] as num? ?? 0).toDouble(),
      commissionParDefaut: (map['commissionParDefaut'] as num? ?? 10)
          .toDouble(),
      status: DealerStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => DealerStatus.enAttente,
      ),
      rating: (map['rating'] as num? ?? 0).toDouble(),
      commandesTraitees: (map['commandesTraitees'] as num? ?? 0).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Dealer.fromJson(String source) =>
      Dealer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Dealer(id: $id, name: $name, zone: $zone, '
      'provisionDisponible: $provisionDisponible, status: $status)';

  @override
  bool operator ==(covariant Dealer other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.provisionDisponible == provisionDisponible &&
        other.provisionBloquee == provisionBloquee &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      provisionDisponible.hashCode ^
      provisionBloquee.hashCode ^
      status.hashCode;
}
