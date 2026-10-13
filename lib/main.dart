import 'package:ai_movie_app/features/app_section/presentation/pages/app_section_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/pages/create_new_password.dart';
import 'package:ai_movie_app/features/auth/presentation/pages/login_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/pages/signup_or_login_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';

import 'package:ai_movie_app/features/favorite/presentation/pages/favorite_screen.dart';
import 'package:ai_movie_app/features/home/presentation/pages/home_screen.dart';

import 'package:ai_movie_app/features/movie_detail/presentation/pages/movie_detail_screen.dart';
import 'package:ai_movie_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/pages/language_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/pages/notification_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:ai_movie_app/features/splash_screen/pages/splash_screen.dart';

import 'package:ai_movie_app/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
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
        AppRoutes.createNewPasswordScreen: (context) =>const CreateNewPassword(),
        AppRoutes.appSectionScreen: (context) =>const AppSectionScreen(),
        AppRoutes.movieDetailScreen: (context) => const MovieDetailScreen(),
        AppRoutes.favoriteScreen: (context) => const FavoriteScreen(),
        AppRoutes.profileScreen: (context) => BlocProvider.value(value: getIt<ProfileCubit>(), child: const ProfileScreen()),
        // Edit Profile needs both ProfileCubit (to read current data) and a
        // fresh EditProfileCubit (to manage unsaved photo state).
        AppRoutes.editProfileScreen: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<ProfileCubit>()),
            BlocProvider(create: (_) => getIt<EditProfileCubit>()),
          ],
          child: const EditProfileScreen(),
        ),
        AppRoutes.notificationScreen: (context) => BlocProvider.value(value: getIt<ProfileCubit>(), child: const NotificationScreen()),
        AppRoutes.languageScreen: (context) => BlocProvider.value(value: getIt<ProfileCubit>(), child: const LanguageScreen()),
        AppRoutes.privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),      },
    );
  }
}

