import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_card.dart';
import 'package:dksoft_market/features/wishlist/application/wishlist_service.dart';
import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListScreen extends ConsumerWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishListValue = ref.watch(wishlistProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoris',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: CustomScrollView(
        slivers: [
          ResponsiveSliderCenter(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.p20,
              vertical: Sizes.p20,
            ),
            child: AsyncValueWidget(
              value: wishListValue,
              data: (wishlists) {
                final items = wishlists.toItemsList();

                return items.isEmpty
                    ? Center(child: Text('No product found'))
                    : CustomLayoutGrid(
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];
                          final product = ref
                              .watch(watchProductProvider(item))
                              .value;

                          return product == null
                              ? SizedBox.shrink()
                              : ProductsCard(product: product);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
