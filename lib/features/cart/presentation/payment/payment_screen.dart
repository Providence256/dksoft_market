import 'package:dksoft_market/features/authentication/data/fake_auth_repository.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/application/checkout_service.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/bill_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/delivery_mode_toggle.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/info_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/note_field.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_bottom_bar.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_header.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/section_card.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/tip_chip.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

const double _kServiceFee = 0.85;
const List<double> _kTipOptions = [1, 3, 5, 10];

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.dealerId});

  final String dealerId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  DeliveryMode _mode = DeliveryMode.home;
  double? _tip;
  bool _saveTip = false;
  String? _note;

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(cartDealerGroupsProvider);
    final matches = groups.where((g) => g.dealer.id == widget.dealerId);
    final group = matches.isEmpty ? null : matches.first;

    if (group == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final user = ref.watch(fakeAuthStateChangeProvider).value;
    final itemsPrice = ref.watch(dealerGroupOriginalTotalProvider(group));
    final discount = ref.watch(dealerGroupDiscountProvider(group));
    final subtotal = ref.watch(dealerGroupTotalProvider(group));
    final tip = _tip ?? 0;
    final total = subtotal + tip + _kServiceFee;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            PaymentHeader(title: 'Caisse'),
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
                          'Adresse de livraison',
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
                          title: user?.username ?? 'Client',
                          subtitle: user?.phoneNumber ?? 'Aucun numéro',
                          onEdit: () => _showComingSoon(context, 'contact'),
                        ),
                        const SizedBox(height: Sizes.p16),
                        Text(
                          'Note de livraison ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Sizes.p8),
                        NoteField(note: _note, onTap: () => _editNote(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SectionCard(
                    child: InkWell(
                      onTap: () => _showComingSoon(context, 'coupon'),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ajouter un coupon',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: Sizes.p4),
                                Text(
                                  'Pour économiser plus, utilisez les coupons disponibles',
                                  style: Theme.of(context).textTheme.labelSmall!
                                      .copyWith(color: AppColors.textHintLight),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.add_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Pourboires de livraison',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: Sizes.p8),
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 14,
                              color: AppColors.textHintLight,
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.p4),
                        Text(
                          'Les pourboires fournis iront à 100 % au livreur.',
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(color: AppColors.textHintLight),
                        ),
                        const SizedBox(height: Sizes.p16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              TipChip(
                                label: 'Autre',
                                selected:
                                    _tip != null &&
                                    !_kTipOptions.contains(_tip),
                                onTap: () => _pickCustomTip(context),
                              ),
                              const SizedBox(width: Sizes.p8),
                              for (final amount in _kTipOptions) ...[
                                TipChip(
                                  label: '\$ ${amount.toStringAsFixed(0)}',
                                  selected: _tip == amount,
                                  onTap: () => setState(() => _tip = amount),
                                ),
                                const SizedBox(width: Sizes.p8),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: Sizes.p10),
                        InkWell(
                          onTap: () => setState(() => _saveTip = !_saveTip),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Enregistrer pour plus tard',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                              Checkbox(
                                value: _saveTip,
                                activeColor: AppColors.primary,
                                onChanged: (v) =>
                                    setState(() => _saveTip = v ?? false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Mode de paiement',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.p4),
                        Text(
                          'Ajoutez au moins une option pour payer votre commande.',
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(color: AppColors.textHintLight),
                        ),
                        const SizedBox(height: Sizes.p16),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(Sizes.p10),
                              ),
                              child: Icon(
                                Icons.money_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: Sizes.p12),
                            Expanded(
                              child: Text(
                                'Paiement à la livraison',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(fontSize: 12),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(total),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
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
                  BillRow(label: "Prix de l'article", value: itemsPrice),
                  BillRow(label: 'Remise', value: -discount),
                  BillRow(label: 'Pourboire pour le livreur', value: tip),
                  BillRow(label: 'Frais de livraison', valueText: 'Gratuit'),
                  BillRow(label: 'Service', value: _kServiceFee),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(
        total: total,
        onConfirm: () => _confirmOrder(context, group, total),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modification $label bientôt disponible.')),
    );
  }

  Future<void> _editNote(BuildContext context) async {
    final controller = TextEditingController(text: _note ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Note de livraison'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ex: Appeler à l’arrivée',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(controller.text.trim()),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _note = result.isEmpty ? null : result);
    }
  }

  Future<void> _pickCustomTip(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pourboire personnalisé'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(prefixText: '\$ '),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () =>
                dialogContext.pop(double.tryParse(controller.text.trim())),
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (result != null && result > 0) {
      setState(() => _tip = result);
    }
  }

  void _confirmOrder(
    BuildContext context,
    DealerCartGroup group,
    double total,
  ) {
    final result = CheckoutService().checkout([group], {group: total}).first;
    final cartService = ref.read(cartServiceProvider);

    if (result.success) {
      for (final item in group.items) {
        cartService.removeItem(item.productId, item.variationId, item.dealerId);
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          result.success ? 'Commande validée' : 'Provision insuffisante',
        ),
        content: Text(
          result.success
              ? 'Commande de ${CurrencyFormatter.format(total)} confirmée chez ${group.dealer.name}.'
              : '${group.dealer.name} ne peut pas encore couvrir cette commande. Réessayez plus tard.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              dialogContext.pop();
              if (result.success) {
                context.goNamed(AppRoute.cart.name);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
