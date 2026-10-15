import 'package:ai_movie_app/features/app_section/presentation/view/screens/app_section_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/view/screens/create_new_password.dart';
import 'package:ai_movie_app/features/auth/presentation/view/screens/login_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/view/screens/reset_password_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/view/screens/signup_or_login_screen.dart';
import 'package:ai_movie_app/features/auth/presentation/view/screens/signup_screen.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';

import 'package:ai_movie_app/features/favorite/presentation/view/screens/favorite_screen.dart';
import 'package:ai_movie_app/features/home/presentation/view/screens/home_screen.dart';

import 'package:ai_movie_app/features/movie_detail/presentation/view/screens/movie_detail_screen.dart';
import 'package:ai_movie_app/features/onboarding/presentation/view/screens/onboarding_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view/screens/edit_profile_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/view/screens/language_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/view/screens/notification_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/view/screens/privacy_policy_screen.dart';
import 'package:ai_movie_app/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:ai_movie_app/features/splash_screen/presentation/view/screens/splash_screen.dart';

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

