import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HeartIconContainer extends StatefulWidget {
  const HeartIconContainer({super.key});

  @override
  State<HeartIconContainer> createState() => _HeartIconContainerState();
}

class _HeartIconContainerState extends State<HeartIconContainer>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: 1.0,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.7,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _isFavorite = !_isFavorite);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(_isFavorite),
              size: Sizes.p32,
              color: _isFavorite
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
