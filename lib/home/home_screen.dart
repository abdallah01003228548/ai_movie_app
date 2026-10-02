import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/home/presentation/cubit/category_chips_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/most_popular_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/today_carousel_cubit.dart';
import 'package:ai_movie_app/home/presentation/widgets/category_chips.dart';
import 'package:ai_movie_app/home/presentation/widgets/home_header.dart';
import 'package:ai_movie_app/home/presentation/widgets/home_search_bar.dart';
import 'package:ai_movie_app/home/presentation/widgets/most_popular_section.dart';
import 'package:ai_movie_app/home/presentation/widgets/today_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomeScreen({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    // Provide cubits scoped to the Home screen
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
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Part 1: Header ──
                const HomeHeader(),
                const SizedBox(height: 20),

                // ── Part 2: Search bar ──
                HomeSearchBar(onTap: onSearchTap),
                const SizedBox(height: 24),

                // ── Part 3: Today carousel ──
                const TodayCarousel(),
                const SizedBox(height: 24),

                // ── Part 4: Category chips ──
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

                // ── Part 5: Most popular ──
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
        ),
      ),
    );
  }
}