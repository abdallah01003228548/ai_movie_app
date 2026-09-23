import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_down_onboarding_page.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/info_box.dart';
import 'package:flutter/material.dart';

class OnboardingPageThere extends StatelessWidget {
  const OnboardingPageThere({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: Stack(
            children: [
              Center(
                child: Transform.scale(
                  scale: 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      AssetsConstant.onboarding2,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 70,
                left: 16,
                child: const InfoBox(
                  icon: Icons.star,
                  label: 'Rating',
                  value: '9/10',
                ),
              ),

              // بادج الـ Duration
              Positioned(
                top: 70,
                right: 16,
                child: const InfoBox(
                  icon: Icons.access_time,
                  label: 'Duration',
                  value: '1h 20m',
                ),
              ),
            ],
          ),
        ),
        Expanded(child: CustomDownOnboardingPage()),
      ],
    );
  }
}
