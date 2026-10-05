import 'package:ai_movie_app/auth/data/repositories/auth_repository.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/home/presentation/cubit/category_chips_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/most_popular_cubit.dart';
import 'package:ai_movie_app/home/presentation/cubit/today_carousel_cubit.dart';
import 'package:ai_movie_app/favorite/data/repositories/favorite_repository.dart';
import 'package:ai_movie_app/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:ai_movie_app/movie_detail/presentation/cubit/movie_detail_cubit.dart';
import 'package:ai_movie_app/search/presentation/cubit/actor_credits_cubit.dart';
import 'package:ai_movie_app/search/presentation/cubit/search_multi_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Call once in main() before runApp().
///
/// Registration rules (see ARCHITECTURE.md §3):
///   - registerLazySingleton → services & repositories (shared, long-lived)
///   - registerFactory       → cubits (fresh instance per screen)
void setupServiceLocator() {
  // ── Services & Repositories ───────────────────────────────────────────────
  // TmdbService: lazy singleton — one Dio instance shared across all cubits.
  getIt.registerLazySingleton<TmdbService>(() => TmdbService());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<FavoriteRepository>(() => FavoriteRepository());

  // ── Cubits (Auth) ─────────────────────────────────────────────────────────
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));

  // ── Cubits (Home) ─────────────────────────────────────────────────────────
  getIt.registerFactory<TodayCarouselCubit>(() => TodayCarouselCubit(getIt<TmdbService>()));
  getIt.registerFactory<CategoryChipsCubit>(() => CategoryChipsCubit(getIt<TmdbService>()));
  getIt.registerFactory<MostPopularCubit>(() => MostPopularCubit(getIt<TmdbService>()));

  // ── Cubits (Search) ───────────────────────────────────────────────────────
  getIt.registerFactory<SearchMultiCubit>(() => SearchMultiCubit(getIt<TmdbService>()));
  getIt.registerFactory<ActorCreditsCubit>(() => ActorCreditsCubit(getIt<TmdbService>()));

  // ── Cubits (Movie Detail) ─────────────────────────────────────────────────
  getIt.registerFactory<MovieDetailCubit>(() => MovieDetailCubit(getIt<TmdbService>()));

  // ── Cubits (Favorite) ─────────────────────────────────────────────────────
  getIt.registerFactory<FavoriteCubit>(() => FavoriteCubit(getIt<FavoriteRepository>()));
}

