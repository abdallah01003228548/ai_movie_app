import 'package:ai_movie_app/core/network/dio_client.dart';
import 'package:ai_movie_app/features/movie_detail/data/data_source/movie_detail_remote_data_source.dart';
import 'package:ai_movie_app/features/movie_detail/data/model/movie_detail_dto.dart';
import 'package:dio/dio.dart';

class MovieDetailRemoteDataSourceImp implements MovieDetailRemoteDataSource {
  final Dio _dio;

  MovieDetailRemoteDataSourceImp({Dio? dio}) : _dio = dio ?? DioClient.instance;

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null && error.response?.data is Map) {
        final message = error.response?.data['status_message'];
        if (message != null) return message as String;
      }
      return error.message ?? 'Network error occurred';
    }
    return error.toString();
  }

  @override
  Future<MovieDetailDto> getMovieDetails(int id) async {
    try {
      final response = await _dio.get(
        '/movie/$id',
        queryParameters: {
          'append_to_response': 'credits,videos,release_dates',
          'language': 'en-US',
        },
      );
      return MovieDetailDto.fromMovieJson(
          response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  @override
  Future<MovieDetailDto> getTvDetails(int id) async {
    try {
      final response = await _dio.get(
        '/tv/$id',
        queryParameters: {
          'append_to_response': 'credits,videos,content_ratings',
          'language': 'en-US',
        },
      );
      return MovieDetailDto.fromTvJson(
          response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }
}
