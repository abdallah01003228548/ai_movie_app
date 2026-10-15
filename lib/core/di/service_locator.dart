import 'package:ai_movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:ai_movie_app/features/auth/data/data_source/auth_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/auth/data/repo/auth_repo_imp.dart';
import 'package:ai_movie_app/features/auth/domain/repo/auth_repo_interface.dart';
import 'package:ai_movie_app/features/auth/domain/use_case/auth_use_cases.dart';
import 'package:ai_movie_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:ai_movie_app/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:ai_movie_app/features/favorite/data/data_source/favorite_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/favorite/data/repo/favorite_repo_imp.dart';
import 'package:ai_movie_app/features/favorite/domain/repo/favorite_repo_interface.dart';
import 'package:ai_movie_app/features/favorite/domain/use_case/favorite_use_cases.dart';
import 'package:ai_movie_app/features/favorite/presentation/view_model/favorite_cubit.dart';
import 'package:ai_movie_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ai_movie_app/features/home/data/data_source/home_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/home/data/repo/home_repo_imp.dart';
import 'package:ai_movie_app/features/home/domain/repo/home_repo_interface.dart';
import 'package:ai_movie_app/features/home/domain/use_case/home_use_cases.dart';
import 'package:ai_movie_app/features/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/category_chips_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/most_popular_cubit.dart';
import 'package:ai_movie_app/features/home/presentation/view_model/today_carousel_cubit.dart';

import 'package:ai_movie_app/features/movie_detail/data/data_source/movie_detail_remote_data_source.dart';
import 'package:ai_movie_app/features/movie_detail/data/data_source/movie_detail_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/movie_detail/data/repo/movie_detail_repo_imp.dart';
import 'package:ai_movie_app/features/movie_detail/domain/repo/movie_detail_repo_interface.dart';
import 'package:ai_movie_app/features/movie_detail/domain/use_case/get_movie_detail_use_case.dart';
import 'package:ai_movie_app/features/movie_detail/presentation/view_model/movie_detail_cubit.dart';
import 'package:ai_movie_app/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:ai_movie_app/features/profile/data/data_source/profile_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/profile/data/repo/profile_repo_imp.dart';
import 'package:ai_movie_app/features/profile/data/services/image_picker_service.dart';
import 'package:ai_movie_app/features/profile/domain/repo/profile_repo_interface.dart';
import 'package:ai_movie_app/features/profile/domain/use_case/profile_use_cases.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:ai_movie_app/features/search/data/data_source/search_remote_data_source.dart';
import 'package:ai_movie_app/features/search/data/data_source/search_remote_data_source_imp.dart';
import 'package:ai_movie_app/features/search/data/repo/search_repo_imp.dart';
import 'package:ai_movie_app/features/search/domain/repo/search_repo_interface.dart';
import 'package:ai_movie_app/features/search/domain/use_case/search_use_cases.dart';
import 'package:ai_movie_app/features/search/presentation/view_model/actor_credits_cubit.dart';
import 'package:ai_movie_app/features/search/presentation/view_model/search_multi_cubit.dart';

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
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<AuthRepoInterface>(
    () => AuthRepoImp(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepoInterface>()),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(getIt<AuthRepoInterface>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepoInterface>()),
  );
  getIt.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(getIt<AuthRepoInterface>()),
  );

  // ImagePickerService: lazy singleton wrapping the image_picker plugin.
  // Registered here so no widget or cubit ever constructs it directly.
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());

  // ── Cubits (Auth) ─────────────────────────────────────────────────────────
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // ── Services & Repositories (Home) ───────────────────────────────────────
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<HomeRepoInterface>(
    () => HomeRepoImp(getIt<HomeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetTrendingTodayUseCase>(
    () => GetTrendingTodayUseCase(getIt<HomeRepoInterface>()),
  );
  getIt.registerLazySingleton<GetGenresUseCase>(
    () => GetGenresUseCase(getIt<HomeRepoInterface>()),
  );
  getIt.registerLazySingleton<GetMostPopularUseCase>(
    () => GetMostPopularUseCase(getIt<HomeRepoInterface>()),
  );

  // ── Cubits (Home) ─────────────────────────────────────────────────────────
  getIt.registerFactory<TodayCarouselCubit>(
    () => TodayCarouselCubit(getIt<GetTrendingTodayUseCase>()),
  );
  getIt.registerFactory<CategoryChipsCubit>(
    () => CategoryChipsCubit(getIt<GetGenresUseCase>()),
  );
  getIt.registerFactory<MostPopularCubit>(
    () => MostPopularCubit(getIt<GetMostPopularUseCase>()),
  );

  // ── Services & Repositories (Search) ─────────────────────────────────────
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<SearchRepoInterface>(
    () => SearchRepoImp(getIt<SearchRemoteDataSource>()),
  );
  getIt.registerLazySingleton<SearchMultiUseCase>(
    () => SearchMultiUseCase(getIt<SearchRepoInterface>()),
  );
  getIt.registerLazySingleton<GetPersonCombinedCreditsUseCase>(
    () => GetPersonCombinedCreditsUseCase(getIt<SearchRepoInterface>()),
  );

  // ── Cubits (Search) ───────────────────────────────────────────────────────
  getIt.registerFactory<SearchMultiCubit>(
    () => SearchMultiCubit(getIt<SearchMultiUseCase>()),
  );
  getIt.registerFactory<ActorCreditsCubit>(
    () => ActorCreditsCubit(getIt<GetPersonCombinedCreditsUseCase>()),
  );

  // ── Services & Repositories (Movie Detail) ──────────────────────────────
  getIt.registerLazySingleton<MovieDetailRemoteDataSource>(
    () => MovieDetailRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<MovieDetailRepoInterface>(
    () => MovieDetailRepoImp(getIt<MovieDetailRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetMovieDetailUseCase>(
    () => GetMovieDetailUseCase(getIt<MovieDetailRepoInterface>()),
  );

  // ── Cubits (Movie Detail) ─────────────────────────────────────────────────
  getIt.registerFactory<MovieDetailCubit>(
    () => MovieDetailCubit(getIt<GetMovieDetailUseCase>()),
  );

  // ── Services & Repositories (Favorite) ──────────────────────────────────
  getIt.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<FavoriteRepoInterface>(
    () => FavoriteRepoImp(getIt<FavoriteRemoteDataSource>()),
  );
  getIt.registerLazySingleton<WatchFavoritesUseCase>(
    () => WatchFavoritesUseCase(getIt<FavoriteRepoInterface>()),
  );
  getIt.registerLazySingleton<WatchIsFavoriteUseCase>(
    () => WatchIsFavoriteUseCase(getIt<FavoriteRepoInterface>()),
  );
  getIt.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(getIt<FavoriteRepoInterface>()),
  );
  getIt.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(getIt<FavoriteRepoInterface>()),
  );

  // ── Cubits (Favorite) ─────────────────────────────────────────────────────
  getIt.registerFactory<FavoriteCubit>(
    () => FavoriteCubit(
      watchFavoritesUseCase: getIt<WatchFavoritesUseCase>(),
      removeFavoriteUseCase: getIt<RemoveFavoriteUseCase>(),
    ),
  );

  // ── Services & Repositories (Profile) ───────────────────────────────────
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImp(),
  );
  getIt.registerLazySingleton<ProfileRepoInterface>(
    () => ProfileRepoImp(getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<WatchProfileUseCase>(
    () => WatchProfileUseCase(getIt<ProfileRepoInterface>()),
  );
  getIt.registerLazySingleton<WatchProfilePhotoUseCase>(
    () => WatchProfilePhotoUseCase(getIt<ProfileRepoInterface>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepoInterface>()),
  );
  getIt.registerLazySingleton<SetNotificationsEnabledUseCase>(
    () => SetNotificationsEnabledUseCase(getIt<ProfileRepoInterface>()),
  );
  getIt.registerLazySingleton<SetLanguageUseCase>(
    () => SetLanguageUseCase(getIt<ProfileRepoInterface>()),
  );
  getIt.registerLazySingleton<SetCountryUseCase>(
    () => SetCountryUseCase(getIt<ProfileRepoInterface>()),
  );

  // ── Cubits (Profile) ──────────────────────────────────────────────────────
  // ProfileCubit: lazy singleton — one long-lived subscription shared by
  // Profile screen, Home header, and any other screen that reads profile data.
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(
      watchProfileUseCase: getIt<WatchProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      setNotificationsEnabledUseCase: getIt<SetNotificationsEnabledUseCase>(),
      setLanguageUseCase: getIt<SetLanguageUseCase>(),
      setCountryUseCase: getIt<SetCountryUseCase>(),
    ),
  );

  // EditProfileCubit: factory — each Edit Profile screen gets a fresh instance
  // so unsaved state is discarded automatically when the screen is popped.
  getIt.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(
      getIt<UpdateProfileUseCase>(),
      getIt<ImagePickerService>(),
    ),
  );
}
