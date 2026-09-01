/// Type de compte choisi à l'inscription (§3/§5.1 du cahier des charges).
/// L'administrateur n'est pas proposé ici : ce rôle est attribué en interne.
enum AccountType {
  client('Client', 'Je cherche et commande des articles'),
  commercant('Commerçant', 'Je vends mes produits sur la plateforme'),
  dealer('Dealer', "Je revends les produits des commerçants"),
  motard('Motard', 'Je livre les commandes en moto');

  const AccountType(this.label, this.description);

  final String label;
  final String description;

  /// Un commerçant, un dealer ou un motard doit être validé par
  /// l'administration avant de pouvoir opérer (§3.2/§3.3/§3.4). Un client
  /// est actif immédiatement.
  bool get requiresAdminValidation => this != AccountType.client;
}
