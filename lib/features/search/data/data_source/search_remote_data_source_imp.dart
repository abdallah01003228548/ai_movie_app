import 'package:ai_movie_app/core/network/dio_client.dart';
import 'package:ai_movie_app/features/home/data/models/movie_model.dart';
import 'package:ai_movie_app/features/home/data/models/person_model.dart';
import 'package:ai_movie_app/features/home/data/models/search_result.dart';
import 'package:ai_movie_app/features/search/data/data_source/search_remote_data_source.dart';
import 'package:dio/dio.dart';

class SearchRemoteDataSourceImp implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImp({Dio? dio}) : _dio = dio ?? DioClient.instance;

  String _handleError(Object e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final message = e.message ?? 'Network error';
      return 'Failed with $statusCode: $message';
    }
    return 'An unexpected error occurred: $e';
  }

  @override
  Future<SearchResult> searchMulti(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/multi',
        queryParameters: {
          'query': query,
          'page': page,
          'include_adult': false,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final rawResults = data['results'] as List<dynamic>;

      final movies = <MovieModel>[];
      final people = <PersonModel>[];

      for (final item in rawResults) {
        final map = item as Map<String, dynamic>;
        final mediaType = map['media_type'] as String?;

        if (mediaType == 'person') {
          people.add(PersonModel.fromJson(map));
        } else if (mediaType == 'movie') {
          movies.add(MovieModel.fromJson(map));
        } else if (mediaType == 'tv') {
          movies.add(
            MovieModel.fromJson({
              ...map,
              'title': map['name'],
              'release_date': map['first_air_date'],
            }),
          );
        }
      }

      return SearchResult(movies: movies, people: people);
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<List<MovieModel>> personCombinedCredits(int personId) async {
    try {
      final response = await _dio.get('/person/$personId/combined_credits');

      final data = response.data as Map<String, dynamic>;
      final cast = data['cast'] as List<dynamic>;

      return cast.map((e) {
        final map = e as Map<String, dynamic>;
        final mediaType = map['media_type'] as String?;
        if (mediaType == 'tv') {
          return MovieModel.fromJson({
            ...map,
            'title': map['name'],
            'release_date': map['first_air_date'],
          });
        }
        return MovieModel.fromJson(map);
      }).toList();
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }
}
