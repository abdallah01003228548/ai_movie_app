import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

abstract interface class HomeRepoInterface {
  Future<List<MovieEntity>> getTrendingToday();
  Future<List<GenreEntity>> getGenres();
  Future<List<MovieEntity>> getMostPopular({int? genreId, int page = 1});
}
