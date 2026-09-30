import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Colours used by the skeleton placeholders (light and dark mode).
class SkeletonColors {
  SkeletonColors._();

  static const Color baseLight = Color(0xFFE6EAF1);
  static const Color highlightLight = Color(0xFFF6F8FB);

  static const Color baseDark = AppColors.cardDark;
  static const Color highlightDark = Color(0xFF2E3846);
}

/// Paints a soft moving highlight over its [child].
///
/// Wrap a group of [SkeletonBox]es with a single [Shimmer] so the whole
/// group sweeps in sync (one animation controller per group, not per box).
///
/// * Adapts to light / dark theme.
/// * Stops animating when the OS asks to reduce motion.
/// * Is announced once to screen readers via [semanticLabel]
///   (pass `null` to hide it from accessibility entirely).
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.semanticLabel = 'Chargement en cours',
  });

  final Widget child;
  final Duration duration;
  final String? semanticLabel;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? SkeletonColors.baseDark : SkeletonColors.baseLight;
    final highlight = isDark
        ? SkeletonColors.highlightDark
        : SkeletonColors.highlightLight;

    Widget result = AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlidingGradientTransform(
                -1.0 + 2.0 * _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );

    result = ExcludeSemantics(child: result);
    final label = widget.semanticLabel;
    return label == null ? result : Semantics(label: label, child: result);
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// A rounded placeholder block. Always place it under a [Shimmer].
///
/// * No [width] / [height]: fills the space it is given.
/// * [widthFactor]: takes that fraction of the available width (0..1).
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  const SkeletonBox.circle({super.key, required double size})
    : width = size,
      height = size,
      widthFactor = null,
      borderRadius = const BorderRadius.all(Radius.circular(999));

  final double? width;
  final double? height;
  final double? widthFactor;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    // The colour is white on purpose: the Shimmer replaces it with the
    // base / highlight gradient (BlendMode.srcATop keeps only the shape).
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius),
    );

    if (widthFactor == null) return box;

    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: box,
    );
  }
}
