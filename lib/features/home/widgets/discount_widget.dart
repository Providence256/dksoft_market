import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/skeleton/skeleton_layouts.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/common/fade_slide_in.dart';
import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/widgets/home_text.dart';
import 'package:dksoft_market/features/merchant/data/fake_merchant_repository.dart';
import 'package:dksoft_market/features/products/data/products_repository.dart';
import 'package:dksoft_market/features/products/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/product_list/product_image_container.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscountWidget extends ConsumerWidget {
  const DiscountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discountProductValue = ref.watch(productsDiscountStreamProvider);
    return AsyncValueWidget(
      value: discountProductValue,
      loading: const DiscountSectionSkeleton(),
      data: (products) => products.isEmpty
          ? const SizedBox.shrink()
          : Column(
              spacing: 10,
              children: [
                const HeaderText(text: 'Offres', subtitle: 'Tout voir'),
                CustomHorizontalList(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * index),
                      offset: const Offset(0.15, 0),
                      child: DiscountProductCard(product: product),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class DiscountProductCard extends ConsumerStatefulWidget {
  const DiscountProductCard({super.key, required this.product});

  final ProductModal product;

  @override
  ConsumerState<DiscountProductCard> createState() =>
      _DiscountProductCardState();
}

class _DiscountProductCardState extends ConsumerState<DiscountProductCard> {
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
              borderRadius: BorderRadius.circular(Sizes.p20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ProductImageContainer(imageUrl: product.images[0]),
                    if (product.reduction > 0)
                      Positioned(
                        top: 12,
                        left: Sizes.p16,
                        child: ReductionContainer(
                          percentage: product.reduction.toInt(),
                        ),
                      ),
                    Positioned(
                      top: Sizes.p16,
                      right: Sizes.p16,
                      child: HeartIconContainer(product: product),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p12,
                    Sizes.p8,
                    Sizes.p12,
                    Sizes.p12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      if (pickupLocation != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.secondary,
                            ),
                            Text(
                              pickupLocation.commune,
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(color: AppColors.textHintLight),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
