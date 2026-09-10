import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/core/domain/dealer_listing.dart';

/// Dealers de test, répartis dans différentes communes de Kinshasa (§8),
/// avec des provisions volontairement variées pour pouvoir tester la règle
/// "provision insuffisante" (§4.2, §6.2) : Dealer '5' est sous-provisionné,
/// et Dealer '4' est encore en attente de validation par l'administration.
const kTestDealers = [
  Dealer(
    id: '1',
    name: 'A - Ngaliema Express',
    phone: '+243810000001',
    zone: 'Ngaliema',
    provisionDisponible: 500,
    provisionBloquee: 50,
    status: DealerStatus.valide,
    rating: 4.7,
    commandesTraitees: 312,
  ),
  Dealer(
    id: '2',
    name: 'B - Lemba Plus',
    phone: '+243810000002',
    zone: 'Lemba',
    provisionDisponible: 260,
    provisionBloquee: 40,
    status: DealerStatus.valide,
    rating: 4.5,
    commandesTraitees: 180,
  ),
  Dealer(
    id: '3',
    name: 'C - Gombe Premium',
    phone: '+243810000003',
    zone: 'Gombe',
    provisionDisponible: 1000,
    provisionBloquee: 0,
    status: DealerStatus.valide,
    rating: 4.9,
    commandesTraitees: 540,
  ),
  Dealer(
    id: '4',
    name: 'D - Limete Rapide',
    phone: '+243810000004',
    zone: 'Limete',
    provisionDisponible: 90,
    provisionBloquee: 0,
    // Pas encore validé : ne peut traiter aucune commande (§6.2).
    status: DealerStatus.enAttente,
    rating: 0,
    commandesTraitees: 0,
  ),
  Dealer(
    id: '5',
    name: 'G - Kintambo Shop',
    phone: '+243810000005',
    zone: 'Kintambo',
    // Volontairement bas pour illustrer "provision insuffisante" au checkout.
    provisionDisponible: 20,
    provisionBloquee: 0,
    status: DealerStatus.valide,
    rating: 4.1,
    commandesTraitees: 76,
  ),
];

const kTestDealerListings = [
  // --- Dealer 1 : A - Ngaliema Express ---
  DealerListing(dealerId: '1', productId: '1', margePourcentage: 8),
  DealerListing(dealerId: '1', productId: '5', margePourcentage: 12),
  DealerListing(dealerId: '1', productId: '2', margePourcentage: 7),
  DealerListing(dealerId: '1', productId: '15', margePourcentage: 10),

  // --- Dealer 2 : B - Lemba Plus ---
  DealerListing(dealerId: '2', productId: '1', margePourcentage: 10),
  DealerListing(dealerId: '2', productId: '5', margePourcentage: 9),
  DealerListing(dealerId: '2', productId: '9', margePourcentage: 15),
  DealerListing(dealerId: '2', productId: '12', margePourcentage: 10),

  // --- Dealer 3 : C - Gombe Premium ---
  DealerListing(dealerId: '3', productId: '1', margePourcentage: 6),
  DealerListing(dealerId: '3', productId: '3', margePourcentage: 8),
  DealerListing(dealerId: '3', productId: '4', margePourcentage: 7),
  DealerListing(dealerId: '3', productId: '13', margePourcentage: 9),

  // --- Dealer 4 : D - Limete Rapide (en attente de validation) ---
  DealerListing(dealerId: '4', productId: '1', margePourcentage: 14),
  DealerListing(dealerId: '4', productId: '7', margePourcentage: 12),

  // --- Dealer 5 : G - Kintambo Shop ---
  DealerListing(dealerId: '5', productId: '5', margePourcentage: 11),
  DealerListing(dealerId: '5', productId: '6', margePourcentage: 13),
  DealerListing(dealerId: '5', productId: '10', margePourcentage: 10),
];
