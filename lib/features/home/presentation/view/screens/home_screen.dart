import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/presentation/view/widget/category_chips.dart';
import 'package:ai_movie_app/features/home/presentation/view/widget/home_header.dart';
import 'package:ai_movie_app/features/home/presentation/view/widget/home_search_bar.dart';
import 'package:ai_movie_app/features/home/presentation/view/widget/most_popular_section.dart';
import 'package:ai_movie_app/features/home/presentation/view/widget/today_carousel.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/category_chips_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/most_popular_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/today_carousel_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_cubit.dart';
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
        // Share the singleton ProfileCubit so HomeHeader can read user data
        BlocProvider.value(value: getIt<ProfileCubit>()),
        BlocProvider(
          create: (_) => getIt<TodayCarouselCubit>()..fetchTrending(),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryChipsCubit>()..fetchGenres(),
        ),
        BlocProvider(
          create: (_) => getIt<MostPopularCubit>()..fetchMostPopular(),
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
                      _ => const <GenreEntity>[],
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