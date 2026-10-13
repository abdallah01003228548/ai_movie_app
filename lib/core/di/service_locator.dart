import 'package:ai_movie_app/features/auth/data/repositories/auth_repository.dart';
import 'package:ai_movie_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_movie_app/features/favorite/data/repositories/favorite_repository.dart';
import 'package:ai_movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:ai_movie_app/features/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/features/home/presentation/cubit/category_chips_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/cubit/most_popular_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/cubit/today_carousel_cubit.dart';

import 'package:ai_movie_app/features/movie_detail/presentation/cubit/movie_detail_cubit.dart';
import 'package:ai_movie_app/features/profile/data/repositories/profile_repository.dart';
import 'package:ai_movie_app/features/profile/data/services/image_picker_service.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:ai_movie_app/features/search/presentation/cubit/actor_credits_cubit.dart';
import 'package:ai_movie_app/features/search/presentation/cubit/search_multi_cubit.dart';

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
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());

  // ImagePickerService: lazy singleton wrapping the image_picker plugin.
  // Registered here so no widget or cubit ever constructs it directly.
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());

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

  // ── Cubits (Profile) ──────────────────────────────────────────────────────
  // ProfileCubit: lazy singleton — one long-lived subscription shared by
  // Profile screen, Home header, and any other screen that reads profile data.
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepository>()));

  // EditProfileCubit: factory — each Edit Profile screen gets a fresh instance
  // so unsaved state is discarded automatically when the screen is popped.
  getIt.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(getIt<ProfileRepository>(), getIt<ImagePickerService>()),
  );
}
