import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/movie_detail/presentation/cubit/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for fetching full movie or TV detail from TMDB.
///
/// Registered as a [registerFactory] in service_locator.dart so that each
/// MovieDetailScreen gets a fresh instance.
class MovieDetailCubit extends Cubit<MovieDetailState> {
  final TmdbService _service;

  MovieDetailCubit(this._service) : super(MovieDetailInitial());

  /// Fetches details for a movie or TV show.
  ///
  /// [id] — TMDB item id.
  /// [mediaType] — "movie" or "tv".
  Future<void> fetchDetail(int id, String mediaType) async {
    emit(MovieDetailLoading());
    try {
      final data = mediaType == 'tv'
          ? await _service.tvDetails(id)
          : await _service.movieDetails(id);
      emit(MovieDetailLoaded(data));
    } catch (e) {
      final raw = e.toString();
      final message = raw.startsWith('Exception: ') ? raw.substring(11) : raw;
      emit(MovieDetailError(message));
    }
  }
}
