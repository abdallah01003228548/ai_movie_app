import 'package:ai_movie_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await getIt<AuthCubit>().logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.splashScreen, (route) => false);
            }
          },
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('Logout', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.activeColorIndicator,
          ),
        ),
      ),
    );
  }
}