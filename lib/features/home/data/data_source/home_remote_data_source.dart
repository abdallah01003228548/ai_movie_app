import 'package:ai_movie_app/features/home/data/models/genre_model.dart';
import 'package:ai_movie_app/features/home/data/models/movie_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrendingToday();
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getMostPopular({int? genreId, int page = 1});
}
