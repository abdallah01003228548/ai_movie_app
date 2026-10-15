import 'package:ai_movie_app/core/network/dio_client.dart';
import 'package:ai_movie_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ai_movie_app/features/home/data/models/genre_model.dart';
import 'package:ai_movie_app/features/home/data/models/movie_model.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImp({Dio? dio}) : _dio = dio ?? DioClient.instance;

  String _handleError(Object e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final message = e.message ?? 'Network error';
      return 'Failed with $statusCode: $message';
    }
    return 'An unexpected error occurred: $e';
  }

  @override
  Future<List<MovieModel>> getTrendingToday() async {
    try {
      final response = await _dio.get(
        '/trending/movie/day',
        queryParameters: {'language': 'en-US'},
      );

      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      return results
          .take(3)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    try {
      final response = await _dio.get(
        '/genre/movie/list',
        queryParameters: {'language': 'en'},
      );

      final data = response.data as Map<String, dynamic>;
      final genres = data['genres'] as List<dynamic>;

      return genres
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<List<MovieModel>> getMostPopular({int? genreId, int page = 1}) async {
    try {
      final String path = genreId == null ? '/movie/popular' : '/discover/movie';
      final queryParams = <String, dynamic>{
        'language': 'en-US',
        'page': page,
      };

      if (genreId != null) {
        queryParams['with_genres'] = genreId;
        queryParams['sort_by'] = 'popularity.desc';
      }

      final response = await _dio.get(path, queryParameters: queryParams);

      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      return results
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }
}
