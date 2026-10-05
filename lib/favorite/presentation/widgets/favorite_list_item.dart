import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/favorite/presentation/widgets/favorite_heart_icon.dart';
import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/movie_detail/presentation/pages/movie_detail_screen.dart';
import 'package:flutter/material.dart';

/// Row item matching the "Wishlist" Figma frame.
///
/// Layout:
/// - Thumbnail with centered play icon overlay
/// - Meta: genre + media-type label ("Action" / "Movie" or "Series")
/// - Title
/// - Star rating (0-5 stars)
/// - Trailing red heart button
class FavoriteListItem extends StatelessWidget {
  final MovieModel movie;
  final String genreName;

  const FavoriteListItem({
    super.key,
    required this.movie,
    this.genreName = '',
  });

  @override
  Widget build(BuildContext context) {
    final filledStars = movie.stars.floor();
    final hasHalf = (movie.stars - filledStars) >= 0.5;

    final mediaLabel = switch (movie.mediaType) {
      'tv' => 'Series',
      'movie' => 'Movie',
      _ => 'Movie',
    };

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.movieDetailScreen,
        arguments: MovieDetailArgs(
          id: movie.id,
          mediaType: movie.mediaType ?? 'movie',
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff252836),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Thumbnail with centered play icon overlay ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 125,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    movie.posterUrl != null
                        ? Image.network(
                            movie.posterUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, e, s) => _placeholder(),
                          )
                        : _placeholder(),
                    // Center play icon overlay
                    Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withAlpha(140),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Title, genre, rating ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Meta row (genre / media type)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (genreName.isNotEmpty)
                          _MetaBadge(
                            label: genreName,
                            icon: Icons.local_movies_outlined,
                          ),
                        _MetaBadge(
                          label: mediaLabel,
                          icon: mediaLabel == 'Series'
                              ? Icons.tv_outlined
                              : Icons.movie_outlined,
                          highlight: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Star rating
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          if (i < filledStars) {
                            return const Icon(
                              Icons.star,
                              color: Color(0xffFFC107),
                              size: 14,
                            );
                          } else if (i == filledStars && hasHalf) {
                            return const Icon(
                              Icons.star_half,
                              color: Color(0xffFFC107),
                              size: 14,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Color(0xffFFC107),
                              size: 14,
                            );
                          }
                        }),
                        const SizedBox(width: 6),
                        Text(
                          movie.stars.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xffFFC107),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Trailing Heart Icon ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FavoriteHeartIcon(
                movie: movie,
                iconSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xff1F1D2B),
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: AppColors.textColor,
          size: 32,
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool highlight;

  const _MetaBadge({
    required this.label,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: highlight ? AppColors.activeColorIndicator : AppColors.textColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: highlight ? AppColors.activeColorIndicator : AppColors.textColor,
            fontSize: 11,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}
