import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/presentation/widgets/cart_total_with_cta.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/constants/breakpoint.dart';
import 'package:flutter/material.dart';

class ShoppingCartItemsBuilder extends StatelessWidget {
  const ShoppingCartItemsBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.ctaBuilder,
  });

  final List<Item> items;
  final Widget Function(BuildContext, Item, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder: (context, index) =>
                    itemBuilder(context, items[index], index),
                itemCount: items.length,
              ),
            ),
            gapW16,
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(Sizes.p16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              itemBuilder: (context, index) =>
                  itemBuilder(context, items[index], index),
              itemCount: items.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
            ),
          ),
        ],
      );
    }
  }
}
