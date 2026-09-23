import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_button.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_down_onboarding_page.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ai_movie_app/onboarding/data_model/onboarding_data_model.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

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
        Expanded(child: CustomDownOnboardingPage()),
      ],
    );
  }
}
