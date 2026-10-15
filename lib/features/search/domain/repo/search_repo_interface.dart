import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/search/domain/entities/search_result_entity.dart';

abstract interface class SearchRepoInterface {
  Future<SearchResultEntity> searchMulti(String query, {int page = 1});
  Future<List<MovieEntity>> personCombinedCredits(int personId);
}
