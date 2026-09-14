import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// A small badge that gently pulses to draw the eye toward new
/// notifications without being distracting.
class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key});

  @override
  State<PulsingDot> createState() => PulsingDotState();
}

class PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.85,
    end: 1.25,
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
      child: Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
    );
  }
}
