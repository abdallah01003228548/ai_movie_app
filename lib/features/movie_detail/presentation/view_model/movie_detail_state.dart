import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';

sealed class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailEntity data;

  MovieDetailLoaded(this.data);
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);
}
