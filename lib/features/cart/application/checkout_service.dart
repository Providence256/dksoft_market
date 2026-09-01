import 'package:dksoft_market/features/cart/application/cart_summary.dart';

/// Résultat du checkout pour UN groupe (= un dealer).
class CheckoutOrderResult {
  const CheckoutOrderResult({
    required this.group,
    required this.total,
    required this.success,
  });

  final DealerCartGroup group;
  final double total;

  /// true si la provision du dealer couvrait le montant et la commande a
  /// été créée ; false si elle a été rejetée pour provision insuffisante
  /// (ou dealer non validé).
  final bool success;
}

/// Implémente l'algorithme "un panier, plusieurs commandes" du cahier des
/// charges (§4.2, §4.3) :
///
/// 1. Le panier est déjà groupé par dealer (voir [cartDealerGroupsProvider]).
/// 2. Pour chaque groupe, on calcule le total et on vérifie la provision.
/// 3. Un dealer sans provision suffisante ne bloque PAS les autres groupes :
///    chaque commande est indépendante.
class CheckoutService {
  List<CheckoutOrderResult> checkout(
    List<DealerCartGroup> groups,
    Map<DealerCartGroup, double> totals,
  ) {
    return groups.map((group) {
      final total = totals[group] ?? 0;
      final dealer = group.dealer;

      // Règle centrale : provision disponible >= montant de CE groupe.
      final success = dealer.peutCouvrir(total);

      // En production : ici on créerait la commande, on bloquerait la
      // provision (Dealer.provisionDisponible -= total,
      // provisionBloquee += total), et on notifierait le dealer.
      return CheckoutOrderResult(group: group, total: total, success: success);
    }).toList();
  }
}
