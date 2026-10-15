import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/domain/repo/home_repo_interface.dart';

class GetTrendingTodayUseCase {
  final HomeRepoInterface _repository;
  const GetTrendingTodayUseCase(this._repository);

  Future<List<MovieEntity>> call() => _repository.getTrendingToday();
}

class GetGenresUseCase {
  final HomeRepoInterface _repository;
  const GetGenresUseCase(this._repository);

  Future<List<GenreEntity>> call() => _repository.getGenres();
}

class GetMostPopularUseCase {
  final HomeRepoInterface _repository;
  const GetMostPopularUseCase(this._repository);

  Future<List<MovieEntity>> call({int? genreId, int page = 1}) =>
      _repository.getMostPopular(genreId: genreId, page: page);
}
