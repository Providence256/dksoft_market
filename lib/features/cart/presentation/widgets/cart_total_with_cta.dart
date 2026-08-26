import 'package:dksoft_market/features/cart/presentation/widgets/cart_total_text.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CartTotalWithCTA extends StatelessWidget {
  const CartTotalWithCTA({super.key, required this.ctaBuilder});
  final WidgetBuilder ctaBuilder;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [CartTotalText(), gapH8, ctaBuilder(context), gapH8],
    );
  }
}
