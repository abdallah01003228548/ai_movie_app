import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Part 5 — Blank/empty state shown when search returns no movie/tv results
/// for a non-empty query.
class SearchBlankView extends StatelessWidget {
  final String query;

  const SearchBlankView({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff252836),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 52,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'We Are Sorry, We Can Not Find The Movie :(',
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
