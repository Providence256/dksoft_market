import 'package:dksoft_market/common/responsive_center.dart';
import 'package:dksoft_market/features/home/widgets/category_Filter_tab.dart';
import 'package:dksoft_market/features/home/widgets/discount_widget.dart';
import 'package:dksoft_market/features/home/widgets/home_annonce.dart';
import 'package:dksoft_market/features/products/presentation/product_list/products_grid.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ResponsiveSliverCenter(
              padding: EdgeInsets.all(13),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: HomeAnnonceContainer(),
              ),
            ),
            ResponsiveSliverCenter(
              padding: EdgeInsets.symmetric(
                vertical: Sizes.p8,
                horizontal: Sizes.p16,
              ),
              child: Column(
                spacing: 10,
                children: [
                  HeaderText(text: 'Categories', subtitle: 'Tout voir'),
                  CategoryFilterTab(),
                ],
              ),
            ),
            ResponsiveSliverCenter(
              padding: EdgeInsets.symmetric(
                vertical: Sizes.p8,
                horizontal: Sizes.p16,
              ),
              child: DiscountWidget(),
            ),
            ResponsiveSliverCenter(
              padding: EdgeInsets.symmetric(
                vertical: Sizes.p8,
                horizontal: Sizes.p16,
              ),
              child: Column(
                spacing: 10,
                children: [
                  HeaderText(text: 'Pres de toi', subtitle: 'Tout voir'),
                  ProductsGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text, required this.subtitle});

  final String text;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: Theme.of(context).textTheme.headlineSmall),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12,
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
      backgroundColor: theme.colorScheme.primary,
      automaticallyImplyLeading: false,
      toolbarHeight: 150,
      elevation: 0,

      titleSpacing: 0,

      title: Padding(
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
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation04,
                          size: Sizes.p16,
                          color: Colors.red,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          'Lemba',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Icon(
                          Icons.keyboard_arrow_down,
                          size: Sizes.p16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),

                // Notification
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.textHintLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Center(
                  child: Row(
                    spacing: 5,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),

                      Text(
                        'Rechercher produit...',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
