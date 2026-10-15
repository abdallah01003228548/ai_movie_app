import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/search/domain/entities/search_result_entity.dart';
import 'package:ai_movie_app/features/search/domain/repo/search_repo_interface.dart';

class SearchMultiUseCase {
  final SearchRepoInterface _repository;
  const SearchMultiUseCase(this._repository);

  Future<SearchResultEntity> call(String query, {int page = 1}) =>
      _repository.searchMulti(query, page: page);
}

class GetPersonCombinedCreditsUseCase {
  final SearchRepoInterface _repository;
  const GetPersonCombinedCreditsUseCase(this._repository);

  Future<List<MovieEntity>> call(int personId) =>
      _repository.personCombinedCredits(personId);
}
