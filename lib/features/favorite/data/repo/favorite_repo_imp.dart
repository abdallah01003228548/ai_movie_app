import 'package:ai_movie_app/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:ai_movie_app/features/favorite/data/model/favorite_movie_dto.dart';
import 'package:ai_movie_app/features/favorite/domain/repo/favorite_repo_interface.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

class FavoriteRepoImp implements FavoriteRepoInterface {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteRepoImp(this._remoteDataSource);

  @override
  Stream<List<MovieEntity>> watchFavorites() {
    return _remoteDataSource
        .watchFavorites()
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }

  @override
  Stream<bool> watchIsFavorite(String? mediaType, int id) {
    return _remoteDataSource.watchIsFavorite(mediaType, id);
  }

  @override
  Future<void> addFavorite(MovieEntity movie) {
    return _remoteDataSource.addFavorite(FavoriteMovieDto.fromEntity(movie));
  }

  @override
  Future<void> removeFavorite(String? mediaType, int id) {
    return _remoteDataSource.removeFavorite(mediaType, id);
  }
}
