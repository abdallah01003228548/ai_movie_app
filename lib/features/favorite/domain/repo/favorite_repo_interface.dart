import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

abstract interface class FavoriteRepoInterface {
  Stream<List<MovieEntity>> watchFavorites();
  Stream<bool> watchIsFavorite(String? mediaType, int id);
  Future<void> addFavorite(MovieEntity movie);
  Future<void> removeFavorite(String? mediaType, int id);
}
