import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/home/presentation/cubit/category_chips_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/most_popular_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/today_carousel_cubit.dart';
import 'package:ai_movie_app/home/presentation/widgets/category_chips.dart';
import 'package:ai_movie_app/home/presentation/widgets/most_popular_section.dart';
import 'package:ai_movie_app/home/presentation/widgets/today_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchIdleView extends StatelessWidget {
  const SearchIdleView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TodayCarouselCubit(TmdbService())..fetchTrending(),
        ),
        BlocProvider(
          create: (_) => CategoryChipsCubit(TmdbService())..fetchGenres(),
        ),
        BlocProvider(
          create: (_) => MostPopularCubit(TmdbService())..fetchMostPopular(),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Trending carousel (reused from Home) ──
            const TodayCarousel(),
            const SizedBox(height: 24),

            // ── Genre filter chips (reused from Home) ──
            Builder(
              builder: (context) {
                return CategoryChips(
                  onGenreSelected: (genreId) {
                    context
                        .read<MostPopularCubit>()
                        .fetchMostPopular(genreId: genreId);
                  },
                );
              }
            ),
            const SizedBox(height: 24),

            // ── Recommend for you (reused MostPopularSection from Home) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommend for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: See All navigation (not yet implemented)
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
            BlocBuilder<CategoryChipsCubit, CategoryChipsState>(
              builder: (context, state) {
                final genres = switch (state) {
                  CategoryChipsLoaded(:final genres) => genres,
                  _ => const <GenreModel>[],
                };
                return MostPopularSection(genres: genres);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
