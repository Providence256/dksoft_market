import 'package:dksoft_market/common/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

/// Network image with a shimmering skeleton while it loads, a smooth
/// fade-in once ready, and a neutral fallback if it fails to load.
class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        imageUrl,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          // Already in the image cache: no skeleton flash.
          if (wasSynchronouslyLoaded) return child;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            layoutBuilder: (current, previous) => Stack(
              fit: StackFit.expand,
              children: [...previous, if (current != null) current],
            ),
            child: frame == null
                ? const Shimmer(
                    key: ValueKey('image-loading'),
                    semanticLabel: null,
                    child: SkeletonBox(borderRadius: BorderRadius.zero),
                  )
                : KeyedSubtree(key: const ValueKey('image-loaded'), child: child),
          );
        },
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: Icon(Icons.image_not_supported_outlined)),
        ),
      ),
    );
  }
}
