import 'package:carousel_slider/carousel_slider.dart';
import 'package:dksoft_market/utils/constants/app_assets.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeAnnonceContainer extends StatelessWidget {
  const HomeAnnonceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    return Stack(
      children: [
        CarouselSlider(
          items: [
            Image(image: AssetImage(AppAssets.banner_1)),
            Image(image: AssetImage(AppAssets.banner_2)),
          ],
          options: CarouselOptions(autoPlay: true, viewportFraction: 1),
        ),
        Positioned(
          bottom: 10,
          right: 24,
          child: SmoothPageIndicator(
            controller: controller,
            count: 2,
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
