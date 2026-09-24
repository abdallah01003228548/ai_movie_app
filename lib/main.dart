import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/home/home_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding1_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding2_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding3_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:ai_movie_app/splash_screen/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onBoardingScreen,
      routes: {
        AppRoutes.splashScreen: (context) => const SplashScreen(),
        AppRoutes.homeScreen: (context) => const HomeScreen(),
        AppRoutes.onBoardingScreen: (context) => const OnboardingScreen(),
      },
    );
  }
}
