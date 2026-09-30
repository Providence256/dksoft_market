import 'package:dksoft_market/common/custom_layout_grid.dart';
import 'package:dksoft_market/common/skeleton/skeleton.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _cardRadius = BorderRadius.all(Radius.circular(Sizes.p20));
const _tileRadius = BorderRadius.all(Radius.circular(Sizes.p16));

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

/// Skeleton of [ProductsCard] (square image + name / price / location).
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: SkeletonBox(borderRadius: _cardRadius),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Sizes.p4,
            Sizes.p12,
            Sizes.p4,
            Sizes.p12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(widthFactor: 0.75, height: 12),
              SizedBox(height: Sizes.p8),
              SkeletonBox(widthFactor: 0.4, height: 14),
              SizedBox(height: Sizes.p8),
              SkeletonBox(widthFactor: 0.55, height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

/// Responsive grid of [ProductCardSkeleton]s.
/// Not scrollable: wrap it in a scroll view if it can exceed the screen.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: CustomLayoutGrid(
        itemCount: itemCount,
        itemBuilder: (_, __) => const ProductCardSkeleton(),
      ),
    );
  }
}

/// Skeleton of the "Offres" section: header + horizontal list of cards.
class DiscountSectionSkeleton extends StatelessWidget {
  const DiscountSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        spacing: 10,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(width: 90, height: 18),
              SkeletonBox(width: 56, height: 12),
            ],
          ),
          CustomHorizontalList(
            itemCount: 4,
            itemBuilder: (_, __) => const _DiscountCardSkeleton(),
          ),
        ],
      ),
    );
  }
}

class _DiscountCardSkeleton extends StatelessWidget {
  const _DiscountCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: SkeletonBox(borderRadius: _cardRadius),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(Sizes.p4, Sizes.p8, Sizes.p4, Sizes.p12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(widthFactor: 0.7, height: 12),
              SizedBox(height: 6),
              SkeletonBox(widthFactor: 0.4, height: 14),
              SizedBox(height: 6),
              SkeletonBox(widthFactor: 0.5, height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

/// Full-screen skeleton for the product details page.
/// Includes a back button so the user is never stuck while loading.
class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Shimmer(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(
                  height: 340,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(Sizes.p32),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonBox(widthFactor: 0.7, height: 26),
                      gapH12,
                      const SkeletonBox(width: 120, height: 22),
                      gapH20,
                      Row(
                        spacing: Sizes.p12,
                        children: [
                          for (var i = 0; i < 4; i++)
                            const SkeletonBox.circle(size: 36),
                        ],
                      ),
                      gapH20,
                      const SkeletonBox(
                        height: 48,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Sizes.p12),
                        ),
                      ),
                      gapH24,
                      const SkeletonBox(height: 12),
                      gapH8,
                      const SkeletonBox(height: 12),
                      gapH8,
                      const SkeletonBox(widthFactor: 0.6, height: 12),
                      gapH24,
                      const SkeletonBox(height: 72, borderRadius: _tileRadius),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: topInset + Sizes.p8,
          left: Sizes.p8,
          child: Material(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            shape: const CircleBorder(),
            elevation: 1,
            child: IconButton(
              tooltip: 'Retour',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

/// Skeleton of the round category chips on the home screen.
class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Sizes.p12,
        children: [
          for (var i = 0; i < 6; i++)
            const SizedBox(
              width: 68,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonBox.circle(size: 64),
                  SizedBox(height: Sizes.p8),
                  SkeletonBox(width: 44, height: 12),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Skeleton of the categories / sub-categories list (rounded bars).
class CategoryListSkeleton extends StatelessWidget {
  const CategoryListSkeleton({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p16,
        ),
        itemCount: itemCount,
        separatorBuilder: (_, __) => gapH12,
        itemBuilder: (_, __) =>
            const SkeletonBox(height: 40, borderRadius: _tileRadius),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lists & details
// ---------------------------------------------------------------------------

/// Skeleton of the orders list (thumbnail + lines + status chip).
class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.p20,
            vertical: Sizes.p12,
          ),
          child: Row(
            children: [
              SkeletonBox(
                width: 56,
                height: 56,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(widthFactor: 0.5, height: 14),
                    SizedBox(height: 6),
                    SkeletonBox(widthFactor: 0.7, height: 12),
                    SizedBox(height: Sizes.p8),
                    Row(
                      children: [
                        SkeletonBox(
                          width: 64,
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        gapW8,
                        SkeletonBox(width: 90, height: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic list skeleton: round avatar + two lines (e.g. dealers picker).
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(Sizes.p20),
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.p8),
          child: Row(
            children: [
              SkeletonBox.circle(size: 44),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(widthFactor: 0.5, height: 14),
                    SizedBox(height: Sizes.p8),
                    SkeletonBox(widthFactor: 0.8, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for detail pages (order details / tracking).
class DetailPageSkeleton extends StatelessWidget {
  const DetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Sizes.p20),
        children: const [
          SkeletonBox(width: 140, height: 22),
          gapH8,
          SkeletonBox(width: 190, height: 12),
          gapH24,
          SkeletonBox(height: 90, borderRadius: _tileRadius),
          gapH16,
          SkeletonBox(height: 64, borderRadius: _tileRadius),
          gapH12,
          SkeletonBox(height: 64, borderRadius: _tileRadius),
          gapH12,
          SkeletonBox(height: 64, borderRadius: _tileRadius),
          gapH24,
          SkeletonBox(height: 120, borderRadius: _tileRadius),
        ],
      ),
    );
  }
}
