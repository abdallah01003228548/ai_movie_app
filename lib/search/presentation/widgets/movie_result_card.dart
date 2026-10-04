import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:flutter/material.dart';

/// A vertical result card used in the Search screen's results list.
///
/// Shows poster, title, year, genre name, media-type badge ("Movie"/"Series"),
/// and a 5-star rating derived from [MovieModel.stars].
/// Runtime and certification are intentionally omitted (not available from
/// search/multi without extra per-item requests).
class MovieResultCard extends StatelessWidget {
  final MovieModel movie;
  final String genreName;

  const MovieResultCard({
    super.key,
    required this.movie,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    final filledStars = movie.stars.floor();
    final hasHalf = (movie.stars - filledStars) >= 0.5;

    // Derive media-type label
    final mediaLabel = switch (movie.mediaType) {
      'tv' => 'Series',
      'movie' => 'Movie',
      _ => '',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff252836),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 95 / 130,
                child: movie.posterUrl != null
                    ? Image.network(
                        movie.posterUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, s) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info column
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 6),
                  // Meta chips row: genre | year | media type
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (genreName.isNotEmpty)
                        _MetaChip(label: genreName, icon: Icons.local_movies_outlined),
                      if (movie.year.isNotEmpty)
                        _MetaChip(label: movie.year, icon: Icons.calendar_today_outlined),
                      if (mediaLabel.isNotEmpty)
                        _MetaChip(
                          label: mediaLabel,
                          icon: mediaLabel == 'Series'
                              ? Icons.tv_outlined
                              : Icons.movie_outlined,
                          highlight: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
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

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool highlight;

  const _MetaChip({
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
