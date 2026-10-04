import 'package:dio/dio.dart';

/// A shared Dio client instance configured for the TMDB API.
class DioClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '37e72f69d36d6612829d97ceb189f7a3');

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {
        'api_key': _apiKey,
      },
    ),
  );
}
