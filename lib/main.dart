import 'package:ai_movie_app/auth/presentation/pages/create_new_password.dart';
import 'package:ai_movie_app/auth/presentation/pages/login_screen.dart';
import 'package:ai_movie_app/auth/presentation/pages/reset_password_screen.dart';
import 'package:ai_movie_app/auth/presentation/pages/signup_or_login_screen.dart';
import 'package:ai_movie_app/auth/presentation/pages/signup_screen.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/home/home_screen.dart';
import 'package:ai_movie_app/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:ai_movie_app/splash_screen/pages/splash_screen.dart';
import 'package:ai_movie_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      routes: {
        AppRoutes.splashScreen: (context) => const SplashScreen(),
        AppRoutes.homeScreen: (context) => const HomeScreen(),
        AppRoutes.onBoardingScreen: (context) => const OnboardingScreen(),
        AppRoutes.signupOrLoginScreen: (context) => const SignupOrLoginScreen(),
        AppRoutes.loginScreen: (context) => const LoginScreen(),
        AppRoutes.signupScreen: (context) => const SignUpScreen(),
        AppRoutes.resetPasswordScreen: (context) => const ResetPasswordScreen(),
        AppRoutes.createNewPasswordScreen: (context) =>
            const CreateNewPassword(),
      },
    );
  }
}
