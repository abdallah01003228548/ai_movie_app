import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';

abstract interface class MovieDetailRepoInterface {
  Future<MovieDetailEntity> getMovieDetails(int id);
  Future<MovieDetailEntity> getTvDetails(int id);
}
