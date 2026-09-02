import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/merchant/data/fake_merchant_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/product_image_container.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsCard extends ConsumerStatefulWidget {
  const ProductsCard({super.key, required this.product});

  final ProductModal product;

  @override
  ConsumerState<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends ConsumerState<ProductsCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final pickupLocation = ref.watch(
      merchantdefaultPickupLocationProvider(product.marchandId),
    );

    final hasReduction = product.reduction > 0;
    final discountedPrice = hasReduction
        ? product.price * (1 - product.reduction / 100)
        : product.price;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: () => context.goNamed(
            AppRoute.product.name,
            pathParameters: {'id': product.id},
          ),
          borderRadius: BorderRadius.circular(Sizes.p20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.p20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_pressed ? 0.02 : 0.06),
                  blurRadius: _pressed ? 6 : 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Sizes.p20),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ProductImageContainer(
                          imageUrl: product.images[0],
                        ),
                      ),
                      if (hasReduction)
                        Positioned(
                          top: 12,
                          left: Sizes.p12,
                          child: ReductionContainer(
                            percentage: product.reduction.toInt(),
                          ),
                        ),
                      Positioned(
                        top: Sizes.p12,
                        right: Sizes.p12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: HeartIconContainer(product: product),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p12,
                    Sizes.p12,
                    Sizes.p12,
                    Sizes.p12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${discountedPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          if (hasReduction) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textHintLight,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          ],
                        ],
                      ),
                      if (pickupLocation != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                pickupLocation.commune,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: AppColors.textHintLight),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
