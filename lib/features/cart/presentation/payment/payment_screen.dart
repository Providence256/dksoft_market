import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/bill_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/delivery_mode_toggle.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/info_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_bottom_bar.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_header.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/section_card.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  DeliveryMode _mode = DeliveryMode.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            PaymentHeader(title: 'Commande'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Sizes.p16),
                children: [
                  DeliveryModeToggle(
                    mode: _mode,
                    onChanged: (m) => setState(() => _mode = m),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adresse du dealer',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Sizes.p16),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedLocation04,
                          title: 'Position actuelle',
                          subtitle:
                              '86Q3+2V8, Goma, Democratic Republic of the Congo',
                          onEdit: () => _showComingSoon(context, 'adresse'),
                        ),
                        const SizedBox(height: Sizes.p16),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedUser,
                          title: 'Client',
                          subtitle: 'Aucun numéro',
                          onEdit: () => _showComingSoon(context, 'contact'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),

                  Text(
                    'Récapitulatif de la facturation',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Sizes.p12),
                  BillRow(label: "Prix de l'article", value: 100),
                  BillRow(label: 'Remise', value: -10),
                  BillRow(label: 'Frais de livraison', valueText: 'Gratuit'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(
        total: 100,
        onConfirm: () => _confirmOrder(context, 10),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modification $label bientôt disponible.')),
    );
  }

  void _confirmOrder(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Commande validée'),
        content: Text(
          'Commande de ${CurrencyFormatter.format(total)} confirmée chez .'
          ' ne peut pas encore couvrir cette commande. Réessayez plus tard.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              dialogContext.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
