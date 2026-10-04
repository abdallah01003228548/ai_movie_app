import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/movie_detail/presentation/cubit/movie_detail_cubit.dart';
import 'package:ai_movie_app/movie_detail/presentation/cubit/movie_detail_state.dart';
import 'package:ai_movie_app/movie_detail/presentation/widgets/cast_crew_list.dart';
import 'package:ai_movie_app/movie_detail/presentation/widgets/movie_detail_header.dart';
import 'package:ai_movie_app/movie_detail/presentation/widgets/story_line_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Route arguments passed when pushing to [MovieDetailScreen].
class MovieDetailArgs {
  final int id;
  final String mediaType;

  const MovieDetailArgs({required this.id, required this.mediaType});
}

/// Full Movie/TV Detail screen.
///
/// Pushed via Navigator.pushNamed with [MovieDetailArgs] as arguments.
/// Uses [MovieDetailCubit] (registered as Factory in GetIt) for data fetching.
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MovieDetailArgs;

    return BlocProvider(
      create: (_) => getIt<MovieDetailCubit>()..fetchDetail(args.id, args.mediaType),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        // No default appBar — custom back button is in the poster area
        extendBodyBehindAppBar: true,
        body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            return switch (state) {
              MovieDetailInitial() || MovieDetailLoading() => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.activeColorIndicator,
                  ),
                ),
              MovieDetailError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.textColor,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message.isNotEmpty ? message : 'Could not load details',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context
                              .read<MovieDetailCubit>()
                              .fetchDetail(args.id, args.mediaType),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.activeColorIndicator,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            '← Go Back',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              MovieDetailLoaded(:final data) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Poster + overlay (back, share, heart) + meta ──
                      MovieDetailHeader(data: data),

                      // ── Story Line ────────────────────────────────────
                      if (data.overview != null && data.overview!.isNotEmpty) ...[
                        StoryLineText(text: data.overview!),
                        const SizedBox(height: 24),
                      ],

                      // ── Cast & Crew ───────────────────────────────────
                      CastCrewList(cast: data.cast),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
