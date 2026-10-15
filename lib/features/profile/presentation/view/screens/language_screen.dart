import 'package:ai_movie_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String? currentLanguage;
          if (state is ProfileLoaded) {
            currentLanguage = state.data.preferredLanguage ?? 'English';
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Suggested',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageItem(context, 'English (UK)', currentLanguage),
              _buildLanguageItem(context, 'English', currentLanguage),
              _buildLanguageItem(context, 'Bahasa Indonesia', currentLanguage),
              const SizedBox(height: 24),
              const Text(
                'Other Languages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageItem(context, 'Arabic', currentLanguage),
              _buildLanguageItem(context, 'Chinese', currentLanguage),
              _buildLanguageItem(context, 'French', currentLanguage),
              _buildLanguageItem(context, 'German', currentLanguage),
              _buildLanguageItem(context, 'Hindi', currentLanguage),
              _buildLanguageItem(context, 'Italian', currentLanguage),
              _buildLanguageItem(context, 'Japanese', currentLanguage),
              _buildLanguageItem(context, 'Korean', currentLanguage),
              _buildLanguageItem(context, 'Portuguese', currentLanguage),
              _buildLanguageItem(context, 'Russian', currentLanguage),
              _buildLanguageItem(context, 'Spanish', currentLanguage),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, String language, String? currentLanguage) {
    final isSelected = language == currentLanguage;
    return InkWell(
      onTap: () {
        context.read<ProfileCubit>().setLanguage(language);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.redAccent,
              ),
          ],
        ),
      ),
    );
  }
}
