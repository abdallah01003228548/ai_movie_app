import 'package:ai_movie_app/features/favorite/data/model/favorite_movie_dto.dart';

abstract interface class FavoriteRemoteDataSource {
  Stream<List<FavoriteMovieDto>> watchFavorites();
  Stream<bool> watchIsFavorite(String? mediaType, int id);
  Future<void> addFavorite(FavoriteMovieDto movie);
  Future<void> removeFavorite(String? mediaType, int id);
}
