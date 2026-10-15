import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/features/favorite/domain/use_case/favorite_use_cases.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';

/// Reusable heart icon wrapped in a StreamBuilder listening to [watchIsFavorite].
///
/// Visual rules:
/// - Not in favorites → outline/unfilled heart icon
/// - In favorites → filled heart icon, red (0xFFFF4D6D)
/// - Tapping it calls add or remove via use case.
class FavoriteHeartIcon extends StatelessWidget {
  final MovieEntity movie;
  final double iconSize;
  final bool showBackground;
  final Color? unfilledColor;
  final VoidCallback? onTapped;

  const FavoriteHeartIcon({
    super.key,
    required this.movie,
    this.iconSize = 18,
    this.showBackground = false,
    this.unfilledColor,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    final watchIsFavorite = getIt<WatchIsFavoriteUseCase>();
    final addFavorite = getIt<AddFavoriteUseCase>();
    final removeFavorite = getIt<RemoveFavoriteUseCase>();
    final mediaType = movie.mediaType ?? 'movie';

    return StreamBuilder<bool>(
      stream: watchIsFavorite(mediaType, movie.id),
      initialData: false,
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;

        final iconWidget = Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          color: isFavorite
              ? const Color(0xFFFF4D6D)
              : (unfilledColor ?? Colors.white),
          size: iconSize,
        );

        Widget child = iconWidget;
        if (showBackground) {
          child = Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(120),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: iconWidget,
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            onTapped?.call();
            try {
              if (isFavorite) {
                await removeFavorite(mediaType, movie.id);
              } else {
                await addFavorite(movie);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Could not update favorite: $e'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          child: child,
        );
      },
    );
  }
}
