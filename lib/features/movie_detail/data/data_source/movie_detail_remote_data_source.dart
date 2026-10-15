import 'package:ai_movie_app/features/movie_detail/data/model/movie_detail_dto.dart';

abstract interface class MovieDetailRemoteDataSource {
  Future<MovieDetailDto> getMovieDetails(int id);
  Future<MovieDetailDto> getTvDetails(int id);
}
