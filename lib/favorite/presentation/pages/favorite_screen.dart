import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:ai_movie_app/favorite/presentation/cubit/favorite_state.dart';
import 'package:ai_movie_app/favorite/presentation/widgets/favorite_empty_state.dart';
import 'package:ai_movie_app/favorite/presentation/widgets/favorite_list_item.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen Favorite list screen.
///
/// Features:
/// - AppBar with back arrow and "Favorite" title
/// - Loading indicator
/// - Error view with retry button
/// - Loaded with items: List of [FavoriteListItem]
/// - Loaded with empty list: [FavoriteEmptyState]
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoriteCubit>(),
      child: const _FavoriteScreenContent(),
    );
  }
}

class _FavoriteScreenContent extends StatefulWidget {
  const _FavoriteScreenContent();

  @override
  State<_FavoriteScreenContent> createState() => _FavoriteScreenContentState();
}

class _FavoriteScreenContentState extends State<_FavoriteScreenContent> {
  List<GenreModel> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await getIt<TmdbService>().genres();
      if (mounted) {
        setState(() => _genres = genres);
      }
    } catch (_) {
      // Best effort
    }
  }

  String _genreName(List<int> genreIds) {
    if (genreIds.isEmpty || _genres.isEmpty) return '';
    for (final g in _genres) {
      if (g.id == genreIds[0]) return g.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xff252836),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        title: const Text(
          'Favorite',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return switch (state) {
            FavoriteLoading() => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.activeColorIndicator,
                ),
              ),
            FavoriteError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.textColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message.isNotEmpty ? message : 'Could not load favorites',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.read<FavoriteCubit>().retry(),
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            color: AppColors.activeColorIndicator,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            FavoriteLoaded(:final items) => items.isEmpty
                ? const FavoriteEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final movie = items[index];
                      return FavoriteListItem(
                        movie: movie,
                        genreName: _genreName(movie.genreIds),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}
