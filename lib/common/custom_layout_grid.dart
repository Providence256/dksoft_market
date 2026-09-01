import 'dart:math';

import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/constants/grid_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class CustomLayoutGrid extends StatelessWidget {
  const CustomLayoutGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = max(2, width ~/ 250);
        final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
        final numRows = (itemCount / crossAxisCount).ceil();
        final rowSizes = List.generate(numRows, (_) => auto);

        return LayoutGrid(
          columnSizes: columnSizes,
          rowSizes: rowSizes,
          rowGap: Sizes.p16,
          columnGap: Sizes.p12,
          children: [
            for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
          ],
        );
      },
    );
  }
}

class CustomHorizontalList extends StatelessWidget {
  const CustomHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemGap = Sizes.p12,
    this.minItemWidth = 250,
    this.maxColumns = 6,
    this.imageAspectRatio = 4 / 3,
    this.footerHeight = 75,
    this.height,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double itemGap;
  final double minItemWidth;
  final int maxColumns;
  final double imageAspectRatio;
  final double footerHeight;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = GridMetrics.of(
          constraints.maxWidth,
          minItemWidth: minItemWidth,
          gap: itemGap,
          maxColumns: maxColumns,
        );

        final resolvedHeight =
            height ?? (metrics.itemWidth / imageAspectRatio) + footerHeight;

        return SizedBox(
          height: resolvedHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (_, __) => SizedBox(width: itemGap),
            itemBuilder: (context, index) => SizedBox(
              width: metrics.itemWidth,
              child: itemBuilder(context, index),
            ),
          ),
        );
      },
    );
  }
}
