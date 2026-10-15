import 'package:ai_movie_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/domain/repo/home_repo_interface.dart';

class HomeRepoImp implements HomeRepoInterface {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImp(this._remoteDataSource);

  @override
  Future<List<MovieEntity>> getTrendingToday() async {
    final models = await _remoteDataSource.getTrendingToday();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<GenreEntity>> getGenres() async {
    final models = await _remoteDataSource.getGenres();
    return models.map((g) => g.toEntity()).toList();
  }

  @override
  Future<List<MovieEntity>> getMostPopular({int? genreId, int page = 1}) async {
    final models = await _remoteDataSource.getMostPopular(
      genreId: genreId,
      page: page,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
