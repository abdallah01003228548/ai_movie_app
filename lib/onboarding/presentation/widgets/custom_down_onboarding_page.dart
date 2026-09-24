import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_button.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_page_indicator.dart';
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
      children: [
        const SizedBox(height: 60),

        Column(
          children: [
            Text(
              'Lorem ipsum dolor sit amet\nconsectetur explicit',
              textAlign: TextAlign.center,
              style: const TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'Semper in cursus magna et eu\n'
              'varius nunc adipiscing. Elementum\n'
              'justo, laoreet id sem semper\n'
              'parturient.',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(AppColors.textColor.value),
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),

        const Spacer(),

        Row(
          children: [
            const Spacer(),

            CustomPageIndicator(controller: pageController, count: count),

            const Spacer(flex: 8),

            CustomNextButton(onTap: onTap),

            const Spacer(),
          ],
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
