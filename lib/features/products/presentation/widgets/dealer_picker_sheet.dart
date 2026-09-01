import 'package:dksoft_market/core/domain/dealer.dart';
import 'package:dksoft_market/features/dealer/data/fake_dealer_repository.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_controller.dart';
import 'package:dksoft_market/features/products/presentation/controller/selected_dealer_controller.dart';
import 'package:dksoft_market/helpers/pricing_calculator.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showDealerPicker(BuildContext context, ProductModal product) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _DealerPickerSheet(product: product),
  );
}

class _DealerPickerSheet extends ConsumerWidget {
  const _DealerPickerSheet({required this.product});
  final ProductModal product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final listings = ref.watch(dealerListingsForProductProvider(product.id));
    final selectedDealerId = ref.watch(selectedDealerProvider);

    final selectedVariation = ref.watch(selectedVariationProvider);
    final basePrice = selectedVariation.id.isNotEmpty
        ? selectedVariation.price
        : product.price;
    final merchantPrice = product.reduction > 0
        ? PricingCalculator.calculateSellingPrice(basePrice, product.reduction)
        : basePrice;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisir un dealer',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${listings.length} dealer(s) proposent ce produit',
              style: theme.textTheme.bodySmall!.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            if (listings.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Aucun dealer ne propose ce produit pour le moment.',
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: listings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    final dealer = ref.watch(
                      dealerByIdProvider(listing.dealerId),
                    );

                    if (dealer == null) return const SizedBox.shrink();

                    return _DealerOfferTile(
                      dealer: dealer,
                      price: listing.prixVente(merchantPrice),
                      margeMontant: listing.margeSur(merchantPrice),
                      margePourcentage: listing.margePourcentage,
                      selected: dealer.id == selectedDealerId,
                      onTap: dealer.estValide
                          ? () {
                              ref.read(selectedDealerProvider.notifier).state =
                                  dealer.id;
                              Navigator.of(context).pop();
                            }
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DealerOfferTile extends StatelessWidget {
  const _DealerOfferTile({
    required this.dealer,
    required this.price,
    required this.margeMontant,
    required this.margePourcentage,
    required this.selected,
    required this.onTap,
  });

  final Dealer dealer;
  final double price;
  final double margeMontant;
  final double margePourcentage;
  final bool selected;
  final VoidCallback? onTap;

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
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  dealer.name.isNotEmpty ? dealer.name[0].toUpperCase() : '?',
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
                      children: [
                        Text(
                          dealer.zone,
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.star, color: AppColors.secondary, size: 12),

                        Text(
                          dealer.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CurrencyFormatter.format(price),
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '+${margePourcentage.toStringAsFixed(0)}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
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
