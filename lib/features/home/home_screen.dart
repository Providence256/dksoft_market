import 'package:dksoft_market/common/fade_slide_in.dart';
import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/home/widgets/category_filter_tab.dart';
import 'package:dksoft_market/features/home/widgets/discount_widget.dart';
import 'package:dksoft_market/features/home/widgets/home_annonce.dart';
import 'package:dksoft_market/features/products/data/fake_product_repository.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_grid.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(discountProductProvider);
            ref.invalidate(watchproductsProvider);
            // Give the indicator a beat so the refresh feels intentional.
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: CustomScrollView(
            slivers: [
              ResponsiveSliderCenter(
                padding: const EdgeInsets.all(13),
                child: FadeSlideIn(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: const HomeAnnonceContainer(),
                  ),
                ),
              ),
              ResponsiveSliderCenter(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8,
                  horizontal: Sizes.p16,
                ),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Column(
                    spacing: 10,
                    children: [
                      HeaderText(
                        text: 'Categories',
                        subtitle: 'Tout voir',
                        onTap: () => context.goNamed(AppRoute.categories.name),
                      ),
                      const CategoryFilterTab(),
                    ],
                  ),
                ),
              ),
              ResponsiveSliderCenter(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8,
                  horizontal: Sizes.p16,
                ),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: const DiscountWidget(),
                ),
              ),
              ResponsiveSliderCenter(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8,
                  horizontal: Sizes.p16,
                ),
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 240),
                  child: const Column(
                    spacing: 10,
                    children: [
                      HeaderText(text: 'Pres de toi', subtitle: 'Tout voir'),
                      ProductsGrid(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: Sizes.p24)),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
    required this.subtitle,
    this.onTap,
  });

  final String text;
  final String subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: theme.textTheme.headlineSmall),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.p8),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.secondary,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: 110,
      elevation: 0,
      titleSpacing: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
      title: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Livrer à',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLocation04,
                            size: Sizes.p16,
                            color: AppColors.secondaryLight,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            'Lemba',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),

                          const SizedBox(width: 5),

                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: Sizes.p16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Notification with a subtle pulsing badge
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedNotification01,
                            color: Colors.white,
                          ),
                        ),
                        const Positioned(
                          top: 10,
                          right: 10,
                          child: _PulsingDot(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        spacing: 8,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedSearch01,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          Expanded(
                            child: Text(
                              'Rechercher produit...',
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}

/// A small badge that gently pulses to draw the eye toward new
/// notifications without being distracting.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.85,
    end: 1.25,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
    );
  }
}
