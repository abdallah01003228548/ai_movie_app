import 'package:ai_movie_app/movie_detail/data/models/movie_detail_model.dart';

/// States for [MovieDetailCubit].
sealed class MovieDetailState {}

/// Initial state — no fetch has been initiated.
final class MovieDetailInitial extends MovieDetailState {}

/// Fetch in progress.
final class MovieDetailLoading extends MovieDetailState {}

/// Fetch succeeded.
final class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailModel data;
  MovieDetailLoaded(this.data);
}

/// Fetch failed with an error message.
final class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);
}
