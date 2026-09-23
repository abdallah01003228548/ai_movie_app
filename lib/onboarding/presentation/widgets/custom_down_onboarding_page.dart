import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_button.dart';
import 'package:ai_movie_app/onboarding/presentation/widgets/custom_page_indicator.dart';
import 'package:flutter/material.dart';

class CustomDownOnboardingPage extends StatelessWidget {
  const CustomDownOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 60),

        Expanded(
          flex: 1,
          child: Column(
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
                'Semper in cursus magna et eu\nvarius nunc adipiscing. Elementum\njusto, laoreet id sem semper\nparturient.',
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
        ),
        Expanded(
          flex: 1,
          child: Row(
            
            children: [
              Spacer(),
              CustomPageIndicator(controller: PageController(), count: 3),
              Spacer(flex: 8),
              CustomNextButton(onTap: () {}),
              Spacer(),
              ]
              
              ),
              
        ),
        SizedBox(height: 30),
    ]);
  }
}
