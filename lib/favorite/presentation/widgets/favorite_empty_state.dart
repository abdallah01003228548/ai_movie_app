import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Blank/empty state matching the "Wishlist - Blank Page" Figma frame.
class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Centered gift box icon in circular container
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff252836),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                size: 52,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'There Is No Movie Yet!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Find your movie by Type title,\ncategories, years, etc',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 13,
                fontFamily: 'Montserrat',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
