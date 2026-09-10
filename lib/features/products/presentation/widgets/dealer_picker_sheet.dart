import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/common/empty_placeholder_widget.dart';
import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/dealer/data/fake_dealer_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/selected_dealer_controller.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChooseDealerScreen extends ConsumerWidget {
  const ChooseDealerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDealerId = ref.watch(selectedDealerProvider);
    final dealerValue = ref.watch(watchAllDealersProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      body: SafeArea(
        child: AsyncValueWidget(
          value: dealerValue,
          data: (dealers) => dealers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmptyPlaceholderWidget(
                        title: 'Dealer',
                        subTitle: 'Aucun dealer disponible',
                        icon: Icons.supervised_user_circle,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choisir un dealer',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${dealers.length} dealer(s) disponible',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: dealers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final listing = dealers[index];
                            final dealer = ref.watch(
                              dealerByIdProvider(listing.id),
                            );
                            if (dealer == null) return const SizedBox.shrink();
                            final eligible = dealer.peutCouvrir(subtotal);
                            return _DealerOfferTile(
                              dealer: dealer,
                              selected: dealer.id == selectedDealerId,
                              price: subtotal,
                              eligible: eligible,
                              onTap: eligible
                                  ? () {
                                      ref
                                          .read(selectedDealerProvider.notifier)
                                          .state = dealer
                                          .id;
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),

                      if (dealers.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            'Le dealer garantit votre commande avec sa provision. '
                            "Vous ne payez qu'a la reception",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      if (dealers.isNotEmpty)
                        SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectedDealerId != null
                                  ? () =>
                                        context.goNamed(AppRoute.checkout.name)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                'Continuer',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _DealerOfferTile extends StatelessWidget {
  const _DealerOfferTile({
    required this.dealer,
    required this.selected,
    required this.onTap,
    required this.price,
    required this.eligible,
  });

  final Dealer dealer;
  final bool selected;
  final VoidCallback? onTap;
  final double price;
  final bool eligible;

  String get unavailableReason {
    if (!dealer.estValide) {
      return "Indisponible - ce dealer n'est pas encore valide";
    }
    return 'Indisponible - sa provision ne couvre pas cette commande';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.2),
              width: selected ? 1.5 : 1,
            ),
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.05)
                : null,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      dealer.name.isNotEmpty
                          ? dealer.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dealer.name,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.secondary,
                              size: 12,
                            ),
                            Text(
                              dealer.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),

                            Expanded(
                              child: Text(
                                '${dealer.commandesTraitees} commandes - ${dealer.zone}',
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!disabled)
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: selected
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.5),
                    ),
                ],
              ),
              SizedBox(height: 10),
              CustomDivider(),
              if (eligible)
                Column(
                  spacing: 5,
                  children: [
                    _StatRow(label: 'Reponds en moyenne en', value: '15 min'),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Provision',
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Suffisante',
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        unavailableReason,
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.labelMedium!.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
