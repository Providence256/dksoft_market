import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_attributes.dart';

import 'package:dksoft_market/helpers/pricing_calculator.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({
    super.key,
    required bool scrolled,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  }) : _scrolled = scrolled;

  final bool _scrolled;
  final ProductModal product;

  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final sellingPrice = PricingCalculator.getSellingPrice(product);
    final formatedPrice = PricingCalculator.getProoductprice(product);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          AnimatedOpacity(
            opacity: _scrolled ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sellingPrice,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (product.reduction != 0) ...[
                const SizedBox(width: 10),
                Text(
                  formatedPrice,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                ReductionContainer(percentage: product.reduction),
              ],
            ],
          ),

          CustomDivider(),

          // Dynamic — reads product.productAttributes / productVariations,
          // so this renders Storage, Color, Size, or any other attribute
          // your catalog defines, with out-of-stock combos disabled.
          // See product_attributes.dart.
          ProductAttributes(product: product),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),

          CustomDivider(),

          // TODO: replace with product.description once available.
          _ProductDescription(description: product.description),

          CustomDivider(),

          // TODO: replace with product.merchant once your model exposes a
          // seller relation (name, avatar, rating, salesCount, verified).
          _MerchantCard(
            name: 'TODO: merchant name',
            avatarUrl: null,
            rating: 4.9,
            salesCount: 2140,
            verified: true,
            onTap: () {
              // TODO: navigate to the merchant's storefront screen.
            },
          ),

          CustomDivider(),

          // TODO: replace with product.merchant.address, the signed-in
          // user's saved address, and a real shipping quote (distance,
          // ETA, price) from your delivery/logistics service.
          const _DeliverySection(
            fromAddress: 'TODO: merchant address (e.g. Amsterdam, NL)',
            toAddress: 'TODO: client address (e.g. Rotterdam, NL)',
            estimatedTime: '2–4 business days',
            price: '€4.99',
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Star rating + review count, shown just under the price.
class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final filled = index < rating.floor();
          final half = !filled && index < rating;
          return Icon(
            half ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
            size: 18,
            color: Colors.amber,
          );
        }),
        const SizedBox(width: 6),
        Text(
          '$rating ($reviewCount reviews)',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

/// Seller / merchant summary card — who you're buying from, their rating,
/// and a shortcut to their storefront. Standard trust signal for a
/// marketplace listing (vs. a single-retailer store).
class _MerchantCard extends StatelessWidget {
  const _MerchantCard({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.salesCount,
    required this.verified,
    required this.onTap,
  });

  final String name;
  final String? avatarUrl;
  final double rating;
  final int salesCount;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (verified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '$rating',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '·  ${_formatSales(salesCount)} sold',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Store', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSales(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}

/// Delivery summary — merchant address → client address, with an
/// estimated delivery window and price. Lets the buyer see shipping
/// cost/timing before committing to "Add to Cart".
class _DeliverySection extends StatelessWidget {
  const _DeliverySection({
    required this.fromAddress,
    required this.toAddress,
    required this.estimatedTime,
    required this.price,
  });

  final String fromAddress;
  final String toAddress;
  final String estimatedTime;
  // Pass null (or an empty string) to display "Free delivery".
  final String? price;

  @override
  Widget build(BuildContext context) {
    final isFree = price == null || price!.isEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery', style: Theme.of(context).textTheme.titleMedium),
              Text(
                isFree ? 'Free' : price!,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isFree
                      ? Colors.green[700]
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Route: merchant -> client, with a dotted connector between
          // the two stops (visually communicates "shipped from A to B").
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    height: 28,
                    child: VerticalDivider(
                      thickness: 1.5,
                      width: 18,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      toAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Estimated arrival: $estimatedTime',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Expandable product description ("Show more" / "Show less").
class _ProductDescription extends StatefulWidget {
  const _ProductDescription({required this.description});

  final String description;

  @override
  State<_ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<_ProductDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            widget.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
          ),
          secondChild: Text(
            widget.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.grey[700]),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _expanded ? 'Show less' : 'Show more',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sticky bottom bar with price + "Add to Cart".
