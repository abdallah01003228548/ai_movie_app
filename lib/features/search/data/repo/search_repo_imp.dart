import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/search/data/data_source/search_remote_data_source.dart';
import 'package:ai_movie_app/features/search/domain/entities/search_result_entity.dart';
import 'package:ai_movie_app/features/search/domain/repo/search_repo_interface.dart';

class SearchRepoImp implements SearchRepoInterface {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepoImp(this._remoteDataSource);

  @override
  Future<SearchResultEntity> searchMulti(String query, {int page = 1}) async {
    final result = await _remoteDataSource.searchMulti(query, page: page);
    return SearchResultEntity(
      movies: result.movies.map((m) => m.toEntity()).toList(),
      people: result.people
          .map(
            (p) => PersonEntity(
              id: p.id,
              name: p.name,
              profilePath: p.profilePath,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<List<MovieEntity>> personCombinedCredits(int personId) async {
    final models = await _remoteDataSource.personCombinedCredits(personId);
    return models.map((m) => m.toEntity()).toList();
  }
}
