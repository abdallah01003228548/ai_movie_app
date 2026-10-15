import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Part 2 — Tappable search bar (non-editable).
///
/// Tapping triggers [onTap] which should switch the bottom nav to the Search
/// tab via [AppSectionCubit.changeIndex(1)].
class HomeSearchBar extends StatelessWidget {
  /// Callback invoked when the search bar is tapped.
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xff252836),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: AppColors.textColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Search',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
