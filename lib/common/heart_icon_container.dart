import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/wishlist/presentation/wishlist_controller.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HeartIconContainer extends ConsumerStatefulWidget {
  const HeartIconContainer({super.key, required this.product});

  final ProductModal product;

  @override
  ConsumerState<HeartIconContainer> createState() => _HeartIconContainerState();
}

class _HeartIconContainerState extends ConsumerState<HeartIconContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: 1.0,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.7,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  void _toggle() async {
    HapticFeedback.lightImpact();
    await ref
        .read(wishlistControllerProvider.notifier)
        .toggleItem(widget.product.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlist = ref.watch(isInWishlistProvider(product.id));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: _toggle,
        icon: ScaleTransition(
          scale: _scale,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              wishlist ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(wishlist),
              size: Sizes.p32,
              color: wishlist
                  ? AppColors.secondary
                  : AppColors.textSecondaryLight.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class ReductionContainer extends StatelessWidget {
  const ReductionContainer({super.key, required this.percentage});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      child: Text(
        '-$percentage%',
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BackButtonIconContainer extends StatelessWidget {
  const BackButtonIconContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.pop(),
        icon: HugeIcon(
          icon: HugeIcons.strokeRoundedArrowLeft02,
          size: Sizes.p24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
