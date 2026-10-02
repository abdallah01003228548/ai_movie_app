import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/presentation/cubit/most_popular_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Part 5 — "Most Popular" horizontal poster list.
///
/// Shows movie posters, star rating, title, and the first genre name.
class MostPopularSection extends StatelessWidget {
  /// The genre list loaded by Part 4, used to look up genre_ids → name.
  final List<GenreModel> genres;

  const MostPopularSection({super.key, required this.genres});

  String _genreName(List<int> genreIds) {
    if (genreIds.isEmpty || genres.isEmpty) return '';
    final firstId = genreIds[0];
    for (final g in genres) {
      if (g.id == firstId) return g.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Most Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to a "See All" screen (not yet implemented)
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.activeColorIndicator,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<MostPopularCubit, MostPopularState>(
          builder: (context, state) {
            return switch (state) {
              MostPopularInitial() || MostPopularLoading() => const SizedBox(
                  height: 240,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.activeColorIndicator,
                    ),
                  ),
                ),
              MostPopularError(:final message) => SizedBox(
                  height: 240,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.isNotEmpty ? message : 'Could not load movies',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.read<MostPopularCubit>().fetchMostPopular(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.activeColorIndicator,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              MostPopularLoaded(:final movies) => movies.isEmpty
                  ? const SizedBox(
                      height: 240,
                      child: Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(color: AppColors.textColor, fontSize: 13),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: movies.length,
                        separatorBuilder: (context, i) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return _MoviePosterCard(
                            movie: movie,
                            genreName: _genreName(movie.genreIds),
                          );
                        },
                      ),
                    ),
            };
          },
        ),
      ],
    );
  }
}

/// Individual poster card for a movie in the Most Popular section.
class _MoviePosterCard extends StatelessWidget {
  final MovieModel movie;
  final String genreName;

  const _MoviePosterCard({
    required this.movie,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    final filledStars = movie.stars.floor();
    final hasHalf = (movie.stars - filledStars) >= 0.5;

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff252836),
              ),
              clipBehavior: Clip.antiAlias,
              child: movie.posterUrl != null
                  ? Image.network(
                      movie.posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, e, s) => _posterPlaceholder(),
                    )
                  : _posterPlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 3),
          // Genre name
          if (genreName.isNotEmpty)
            Text(
              genreName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 11,
                fontFamily: 'Montserrat',
              ),
            ),
          const SizedBox(height: 4),
          // Star rating
          Row(
            children: List.generate(5, (i) {
              if (i < filledStars) {
                return const Icon(Icons.star, color: Color(0xffFFC107), size: 14);
              } else if (i == filledStars && hasHalf) {
                return const Icon(Icons.star_half, color: Color(0xffFFC107), size: 14);
              } else {
                return const Icon(Icons.star_border, color: Color(0xffFFC107), size: 14);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      color: const Color(0xff252836),
      width: double.infinity,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: AppColors.textColor,
          size: 36,
        ),
      ),
    );
  }
}
