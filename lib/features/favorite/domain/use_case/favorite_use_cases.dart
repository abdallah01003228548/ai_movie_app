import 'package:ai_movie_app/features/favorite/domain/repo/favorite_repo_interface.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

class WatchFavoritesUseCase {
  final FavoriteRepoInterface _repository;
  const WatchFavoritesUseCase(this._repository);

  Stream<List<MovieEntity>> call() => _repository.watchFavorites();
}

class WatchIsFavoriteUseCase {
  final FavoriteRepoInterface _repository;
  const WatchIsFavoriteUseCase(this._repository);

  Stream<bool> call(String? mediaType, int id) =>
      _repository.watchIsFavorite(mediaType, id);
}

class AddFavoriteUseCase {
  final FavoriteRepoInterface _repository;
  const AddFavoriteUseCase(this._repository);

  Future<void> call(MovieEntity movie) => _repository.addFavorite(movie);
}

class RemoveFavoriteUseCase {
  final FavoriteRepoInterface _repository;
  const RemoveFavoriteUseCase(this._repository);

  Future<void> call(String? mediaType, int id) =>
      _repository.removeFavorite(mediaType, id);
}
