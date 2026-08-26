import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/constants/breakpoint.dart';
import 'package:flutter/material.dart';

class ResponsiveScrollableCard extends StatelessWidget {
  const ResponsiveScrollableCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: EdgeInsets.all(Sizes.p16),
          child: Card(
            child: Padding(padding: EdgeInsets.all(Sizes.p16), child: child),
          ),
        ),
      ),
    );
  }
}

class ResponsiveHorizontalScrollableCard extends StatelessWidget {
  const ResponsiveHorizontalScrollableCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: EdgeInsets.all(Sizes.p16),
          child: Card(
            child: Padding(padding: EdgeInsets.all(Sizes.p16), child: child),
          ),
        ),
      ),
    );
  }
}
