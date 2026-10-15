import 'package:ai_movie_app/features/home/data/models/movie_model.dart';
import 'package:ai_movie_app/features/home/data/models/search_result.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchResult> searchMulti(String query, {int page = 1});
  Future<List<MovieModel>> personCombinedCredits(int personId);
}
