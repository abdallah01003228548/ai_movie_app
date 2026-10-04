import 'package:ai_movie_app/core/network/dio_client.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/data/models/person_model.dart';
import 'package:ai_movie_app/home/data/models/search_result.dart';
import 'package:ai_movie_app/movie_detail/data/models/movie_detail_model.dart';
import 'package:dio/dio.dart';

/// Service for accessing the TMDB (The Movie Database) REST API.
///
/// Uses [DioClient] which automatically appends `api_key` and sets the base URL.
class TmdbService {
  static const String _imageBase = 'https://image.tmdb.org/t/p/w500';

  /// Image base URL exposed for widgets that may need it.
  static String get imageBaseUrl => _imageBase;

  final Dio _dio = DioClient.instance;

  String _handleError(Object e) {
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      final message = e.message ?? 'Network error';
      return 'Failed with $statusCode: $message';
    }
    return 'An unexpected error occurred: $e';
  }

  /// GET /trending/movie/day
  Future<List<MovieModel>> trendingToday() async {
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

  /// GET /genre/movie/list
  Future<List<GenreModel>> genres() async {
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

  /// GET /movie/popular (when [genreId] is null)
  /// GET /discover/movie (when [genreId] is provided)
  Future<List<MovieModel>> mostPopular({int? genreId, int page = 1}) async {
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

  /// GET /search/multi
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

  /// GET /person/{person_id}/combined_credits
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

  /// GET /movie/{id}?append_to_response=credits,videos,release_dates
  ///
  /// Returns full movie detail including cast, trailer key, and US certification.
  Future<MovieDetailModel> movieDetails(int id) async {
    try {
      final response = await _dio.get(
        '/movie/$id',
        queryParameters: {
          'append_to_response': 'credits,videos,release_dates',
          'language': 'en-US',
        },
      );
      return MovieDetailModel.fromMovieJson(
          response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// GET /tv/{id}?append_to_response=credits,videos,content_ratings
  ///
  /// Returns full TV show detail including cast, trailer key, and US content rating.
  Future<MovieDetailModel> tvDetails(int id) async {
    try {
      final response = await _dio.get(
        '/tv/$id',
        queryParameters: {
          'append_to_response': 'credits,videos,content_ratings',
          'language': 'en-US',
        },
      );
      return MovieDetailModel.fromTvJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }
}
