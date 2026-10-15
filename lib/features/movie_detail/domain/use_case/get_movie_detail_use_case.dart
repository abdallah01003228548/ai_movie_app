import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';
import 'package:ai_movie_app/features/movie_detail/domain/repo/movie_detail_repo_interface.dart';

class GetMovieDetailUseCase {
  final MovieDetailRepoInterface _repository;

  const GetMovieDetailUseCase(this._repository);

  Future<MovieDetailEntity> call(int id, String mediaType) {
    if (mediaType == 'tv') {
      return _repository.getTvDetails(id);
    }
    return _repository.getMovieDetails(id);
  }
}
