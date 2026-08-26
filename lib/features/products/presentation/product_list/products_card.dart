import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/product_list/product_image_container.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({super.key, required this.product});

  final ProductModal product;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final shadowColor = isDark ? AppColors.shadowDark : AppColors.shadowLight;

    return InkWell(
      onTap: () => context.goNamed(
        AppRoute.product.name,
        pathParameters: {'id': product.id},
      ),
      borderRadius: BorderRadius.circular(Sizes.p20),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(Sizes.p20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
                const Positioned(
                  top: Sizes.p16,
                  right: Sizes.p16,
                  child: HeartIconContainer(),
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
