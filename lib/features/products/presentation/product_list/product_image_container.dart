import 'package:dksoft_market/common/custom_image.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ProductImageContainer extends StatelessWidget {
  const ProductImageContainer({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 4 / 3,
  });

  final String imageUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.p20)),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CustomImage(imageUrl: imageUrl),
      ),
    );
  }
}
