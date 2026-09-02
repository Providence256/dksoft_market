import 'package:carousel_slider/carousel_slider.dart';
import 'package:dksoft_market/utils/constants/app_assets.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const _banners = [AppAssets.banner_1, AppAssets.banner_2];

class HomeAnnonceContainer extends StatefulWidget {
  const HomeAnnonceContainer({super.key});

  @override
  State<HomeAnnonceContainer> createState() => _HomeAnnonceContainerState();
}

class _HomeAnnonceContainerState extends State<HomeAnnonceContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: _banners
              .map(
                (banner) => Stack(
                  fit: StackFit.expand,
                  children: [
                    _KenBurnsImage(imagePath: banner),
                    // Subtle scrim so the dot indicator stays legible over
                    // any banner artwork.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 14 / 8,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 700),
            autoPlayCurve: Curves.easeInOutCubic,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        Positioned(
          bottom: 12,
          right: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: _banners.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 6,
              activeDotColor: AppColors.primary,
              dotColor: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

/// Slowly zooms an image in a loop to give an otherwise static banner a
/// bit of life ("Ken Burns" effect), without needing any extra packages.
class _KenBurnsImage extends StatefulWidget {
  const _KenBurnsImage({required this.imagePath});

  final String imagePath;

  @override
  State<_KenBurnsImage> createState() => _KenBurnsImageState();
}

class _KenBurnsImageState extends State<_KenBurnsImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 1.08,
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
      child: Image.asset(widget.imagePath, fit: BoxFit.cover),
    );
  }
}
