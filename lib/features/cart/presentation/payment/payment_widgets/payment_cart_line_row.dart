import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/products/domain/product_modal.dart';
import 'package:dksoft_market/features/products/presentation/controller/product_variation_controller.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentCartLineRow extends ConsumerWidget {
  const PaymentCartLineRow({
    super.key,
    required this.product,
    required this.item,
  });

  final ProductModal product;
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final unitPrice = ref.watch(productPriceProvider(item));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        spacing: 10,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              product.images.isNotEmpty ? product.images.first : '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge!.copyWith(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Qté: ',
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: '${item.quantity}',
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(unitPrice),
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
