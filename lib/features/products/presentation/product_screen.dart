import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/common/fade_slide_in.dart';
import 'package:dksoft_market/features/merchant/data/fake_merchant_repository.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/widgets/buy_bottom_bar.dart';
import 'package:dksoft_market/features/products/presentation/widgets/marchand_card.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_attributes.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_description.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_price.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_quantity.dart';
import 'package:dksoft_market/features/products/presentation/widgets/product_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  bool _scrolled = false;

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productValue = ref.watch(watchProductProvider(widget.productId));

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          final scrolled = notification.metrics.pixels > 150;
          // Avoid calling setState on every scroll delta, only on flips.
          if (scrolled != _scrolled) {
            setState(() => _scrolled = scrolled);
          }
        }
        return false;
      },
      child: Scaffold(
        body: AsyncValueWidget(
          value: productValue,
          data: (product) {
            if (product == null) {
              return const Center(child: Text('No data found'));
            }

            final merchant = ref.watch(
              merchantByIdProvider(product.marchandId),
            );

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // SliverAppBar
                    ProductSliverAppBar(scrolled: _scrolled, product: product),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            // product title
                            AnimatedOpacity(
                              opacity: _scrolled ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                product.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                            ),
                            //Product Price
                            FadeSlideIn(
                              delay: Duration(milliseconds: 60),
                              child: ProductPrice(product: product),
                            ),
                            CustomDivider(),
                            FadeSlideIn(
                              delay: Duration(milliseconds: 120),
                              child: ProductAttributes(product: product),
                            ),
                            FadeSlideIn(
                              delay: Duration(milliseconds: 160),
                              child: ProductQuantity(product: product),
                            ),
                            CustomDivider(),
                            FadeSlideIn(
                              delay: Duration(milliseconds: 200),
                              child: ProductDescription(product: product),
                            ),
                            CustomDivider(),
                            FadeSlideIn(
                              delay: Duration(milliseconds: 240),
                              child: MarchandCard(
                                name: merchant.name,
                                avatarUrl: merchant.avatarUrl,
                                rating: merchant.rating,
                                salesCount: merchant.salesCount,
                                verified: merchant.verified,
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 110)),
                  ],
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BuyBottomBar(product: product),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
