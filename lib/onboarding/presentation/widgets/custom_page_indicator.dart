import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const CustomPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ExpandingDotsEffect(
        spacing: 10.0,
        activeDotColor: AppColors.activeColorIndicator,
        dotColor: AppColors.dotColorIndicator,
      ),
    );
  }
}
