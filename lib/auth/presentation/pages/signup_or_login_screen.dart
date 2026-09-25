import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/services/social_auth_service.dart';
import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignupOrLoginScreen extends StatefulWidget {
  const SignupOrLoginScreen({super.key});

  @override
  State<SignupOrLoginScreen> createState() => _SignupOrLoginScreenState();
}

class _SignupOrLoginScreenState extends State<SignupOrLoginScreen> {
  final SocialAuthService _socialAuthService = SocialAuthService();
  bool isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userCredential = await _socialAuthService.signInWithGoogle();

      if (!mounted) return;

      if (userCredential != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign in failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userCredential = await _socialAuthService.signInWithFacebook();

      if (!mounted) return;

      if (userCredential != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook sign in failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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

              CustomButton(
                text: 'Sign Up',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.signupScreen);
                },
              ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.loginScreen);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.activeColorIndicator,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
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
              const SizedBox(height: 30),

              if (isLoading)
                const CircularProgressIndicator(
                  color: AppColors.activeColorIndicator,
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(AssetsConstant.google),
                      onPressed: _handleGoogleSignIn,
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: _handleFacebookSignIn,
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
