import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/auth/data/repositories/auth_repository.dart';
import 'package:ai_movie_app/features/profile/data/repositories/profile_repository.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:ai_movie_app/features/profile/presentation/widgets/confirm_dialog.dart';
import 'package:ai_movie_app/features/profile/presentation/widgets/premium_banner.dart';
import 'package:ai_movie_app/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:ai_movie_app/features/profile/presentation/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (state is ProfileLoaded) {
            final data = state.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildProfileHeader(context, data),
                  const PremiumBanner(),
                  _buildSectionTitle('Account'),
                  SettingsRow(
                    icon: Icons.person_outline,
                    label: 'Member',
                    valueText: 'Free',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Premium coming soon')),
                      );
                    },
                  ),
                  SettingsRow(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () async {
                      try {
                        await getIt<AuthRepository>()
                            .sendPasswordResetEmail(data.email);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password reset email sent')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('General'),
                  SettingsRow(
                    icon: Icons.notifications_none,
                    label: 'Notification',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.notificationScreen),
                  ),
                  SettingsRow(
                    icon: Icons.language,
                    label: 'Language',
                    valueText: data.preferredLanguage ?? 'English',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.languageScreen),
                  ),
                  SettingsRow(
                    icon: Icons.flag_outlined,
                    label: 'Country',
                    valueText: data.country ?? 'United States',
                    onTap: () {
                      _showCountryDialog(
                          context, data.country ?? 'United States');
                    },
                  ),
                  SettingsRow(
                    icon: Icons.delete_outline,
                    label: 'Clear Cache',
                    onTap: () {
                      PaintingBinding.instance.imageCache.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache cleared')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('More'),
                  SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Legal and Policies',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.privacyPolicyScreen),
                  ),
                  SettingsRow(
                    icon: Icons.help_outline,
                    label: 'Help & Feedback',
                    onTap: () {},
                  ),
                  SettingsRow(
                    icon: Icons.info_outline,
                    label: 'About Us',
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () => _showLogOutDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.activeColorIndicator,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          const ProfileAvatar(radius: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.fullName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xff00C9E0)),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.editProfileScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showCountryDialog(BuildContext context, String currentCountry) {
    final countries = [
      'United States',
      'United Kingdom',
      'Canada',
      'Australia',
      'India',
      'Egypt'
    ];
    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: getIt<ProfileCubit>(),
          child: Builder(builder: (dialogCtx) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1F1D2B),
              title: const Text('Select Country',
                  style: TextStyle(color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final c = countries[index];
                    return ListTile(
                      title:
                          Text(c, style: const TextStyle(color: Colors.white)),
                      trailing: c == currentCountry
                          ? const Icon(Icons.check, color: Colors.redAccent)
                          : null,
                      onTap: () {
                        dialogCtx.read<ProfileCubit>().setCountry(c);
                        Navigator.pop(dialogCtx);
                      },
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Log Out',
        body: 'Are you sure you want to log out?',
        icon: Icons.warning_amber_rounded,
        confirmText: 'Log Out',
        cancelText: 'Cancel',
        onCancel: () => Navigator.pop(ctx),
        onConfirm: () async {
          Navigator.pop(ctx);
          await getIt<AuthRepository>().logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
              (route) => false,
            );
          }
        },
      ),
    );
  }
}