import 'package:dksoft_market/common/custom_curved_edges.dart';
import 'package:dksoft_market/common/heart_icon_container.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductSliverAppBar extends StatefulWidget {
  const ProductSliverAppBar({
    super.key,
    required this.scrolled,
    required this.product,
  });

  final bool scrolled;

  final ProductModal product;

  @override
  State<ProductSliverAppBar> createState() => _ProductSliverAppBarState();
}

class _ProductSliverAppBarState extends State<ProductSliverAppBar> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 340,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: AnimatedOpacity(
        // was `00` — a bug that always rendered the title fully transparent
        opacity: widget.scrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Text(
          widget.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      leading: AnimatedOpacity(
        opacity: widget.scrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          // prevents invisible icons from eating taps pre-scroll
          ignoring: !widget.scrolled,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
      actions: [
        AnimatedOpacity(
          opacity: widget.scrolled ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: IgnorePointer(
            ignoring: !widget.scrolled,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: CustomCurvedEdges(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.product.images.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      image: DecorationImage(
                        image: AssetImage(widget.product.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),

              // Soft top gradient so the back/heart icons
              // stay legible over bright product photos.
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 120,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x40000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ),
              ),

              if (widget.product.images.length > 1)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.product.images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),

              if (!widget.scrolled)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: const HeartIconContainer(),
                ),
              if (!widget.scrolled)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  child: const BackButtonIconContainer(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
