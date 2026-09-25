import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignupOrLoginScreen extends StatelessWidget {
  const SignupOrLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetsConstant.tv, width: 100, height: 100),
              const SizedBox(height: 12),

              const Text(
                'CINEMAX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),

              Text(
                textAlign: TextAlign.center,
                'enter your registered \nphone number to sign up',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(text: 'Sign Up', onTap: () {}),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I already have an account? ',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.activeColorIndicator,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text(
                'or sign up with ',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(AssetsConstant.google),
                    onPressed: () {},
                    
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    onPressed: () {},
                    
                    icon: Image.asset(AssetsConstant.facebook),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
