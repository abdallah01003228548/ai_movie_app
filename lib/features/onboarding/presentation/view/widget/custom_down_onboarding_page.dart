import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/onboarding/presentation/view/widget/custom_button.dart';
import 'package:ai_movie_app/features/onboarding/presentation/view/widget/custom_page_indicator.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDownOnboardingPage extends StatelessWidget {
  CustomDownOnboardingPage({
    super.key,
    required this.pageController,
    required this.count,
    required this.onTap,
  });
  PageController pageController;
  int count;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Embrace your \n choice with ease',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Search through a wide selection and \n enjoy the best movie experience',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: AppColors.textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomPageIndicator(controller: pageController, count: count),
              CustomNextButton(onTap: onTap),
            ],
          ),
        ),
      ],
    );
  }
}
