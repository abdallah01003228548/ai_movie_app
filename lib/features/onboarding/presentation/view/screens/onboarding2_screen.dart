import 'package:ai_movie_app/features/onboarding/presentation/view/widget/custom_down_onboarding_page.dart';
import 'package:ai_movie_app/features/onboarding/presentation/view/widget/movie_carousel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Onboarding2Screen extends StatelessWidget {
  Onboarding2Screen({
    super.key,
    required this.pageController,
    required this.count,
    required this.onTap,
  });
  final PageController pageController;
  final int count;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MovieCarousel(),
        Expanded(
          child: CustomDownOnboardingPage(
            pageController: pageController,
            count: count,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
