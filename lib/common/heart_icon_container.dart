import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HeartIconContainer extends StatelessWidget {
  const HeartIconContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.favorite_border,
          size: Sizes.p32,
          color: AppColors.textSecondaryLight.withValues(alpha: 0.7),
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
