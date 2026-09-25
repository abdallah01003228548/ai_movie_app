import 'dart:async';

import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';

import 'package:ai_movie_app/core/theme/app_colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      // First time user: show onboarding
      Navigator.pushReplacementNamed(context, AppRoutes.onBoardingScreen);
    } else if (currentUser != null) {
      // User is logged in: go to home
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else {
      // User has seen onboarding but not logged in: go to signup/login
      Navigator.pushReplacementNamed(context, AppRoutes.signupOrLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(child: SvgPicture.asset(AssetsConstant.iconSplashScreen)),
    );
  }
}
