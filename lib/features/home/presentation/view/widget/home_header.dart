import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:ai_movie_app/features/profile/presentation/view/widget/profile_avatar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Part 1 — Header showing avatar + "Hello, {displayName}".
///
/// The avatar is rendered by [ProfileAvatar], which subscribes to its own
/// lightweight photo stream. The name still comes from [ProfileCubit] exactly
/// as before — no change to greeting logic.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String name = 'Guest';

        if (state is ProfileLoaded) {
          name = state.data.fullName ?? state.data.email.split('@').first;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Avatar — replaced with shared ProfileAvatar (photo stream).
              // Size 22 matches the original 44×44 px container.
              const ProfileAvatar(radius: 22),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Heart / notification icon navigating to Favorite screen
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.chatScreen),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff252836),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
