import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding1_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding2_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding3_screen.dart';

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  OnboardingPageOne(
                    pageController: pageController,
                    count: 3,
                    onTap: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),

                  Onboarding2Screen(
                    pageController: pageController,
                    count: 3,
                    onTap: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),

                  OnboardingPageThere(
                    pageController: pageController,
                    count: 3,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signupOrLoginScreen);
                      // Go to Home
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
