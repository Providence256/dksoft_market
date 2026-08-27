import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/vendor_group_header.dart';
import 'package:dksoft_market/features/cart/presentation/widgets/cart_total_with_cta.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/constants/breakpoint.dart';
import 'package:flutter/material.dart';

class ShoppingCartItemsBuilder extends StatelessWidget {
  const ShoppingCartItemsBuilder({
    super.key,
    required this.groups,
    required this.itemBuilder,
    required this.ctaBuilder,
  });

  final List<VendorCartGroup> groups;
  final Widget Function(BuildContext, Item, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  /// Flattens the vendor groups into a single widget list: a header for
  /// each vendor followed by that vendor's item rows.
  List<Widget> _buildSections(BuildContext context) {
    final widgets = <Widget>[];
    var index = 0;

    for (final group in groups) {
      widgets.add(VendorGroupHeader(group: group));

      for (final item in group.items) {
        widgets.add(itemBuilder(context, item, index));
        index++;
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sections = _buildSections(context);

    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: sections,
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              children: sections,
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
