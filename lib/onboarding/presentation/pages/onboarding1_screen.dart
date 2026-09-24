import 'package:ai_movie_app/core/constant/assets_constant.dart';

import 'package:ai_movie_app/onboarding/presentation/widgets/custom_down_onboarding_page.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OnboardingPageOne extends StatelessWidget {
  OnboardingPageOne({
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
        Image.asset(
          AssetsConstant.onboarding,
          width: double.infinity,
          height: 500,
          fit: BoxFit.cover,
        ),
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
