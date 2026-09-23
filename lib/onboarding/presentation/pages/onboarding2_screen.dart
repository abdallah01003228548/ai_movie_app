import 'package:ai_movie_app/onboarding/presentation/widgets/custom_down_onboarding_page.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/movie_carousel.dart';
import 'package:flutter/material.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MovieCarousel(),
        Expanded(child: CustomDownOnboardingPage()),
      ],
    ); 
  }
}