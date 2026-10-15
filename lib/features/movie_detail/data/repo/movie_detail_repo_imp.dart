import 'package:ai_movie_app/features/movie_detail/data/data_source/movie_detail_remote_data_source.dart';
import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';
import 'package:ai_movie_app/features/movie_detail/domain/repo/movie_detail_repo_interface.dart';

class MovieDetailRepoImp implements MovieDetailRepoInterface {
  final MovieDetailRemoteDataSource _remoteDataSource;

  MovieDetailRepoImp(this._remoteDataSource);

  @override
  Future<MovieDetailEntity> getMovieDetails(int id) async {
    final dto = await _remoteDataSource.getMovieDetails(id);
    return dto.toEntity();
  }

  @override
  Future<MovieDetailEntity> getTvDetails(int id) async {
    final dto = await _remoteDataSource.getTvDetails(id);
    return dto.toEntity();
  }
}
