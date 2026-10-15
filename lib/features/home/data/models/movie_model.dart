import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

/// Represents a movie from the TMDB API.
///
/// Used by both the trending/movie/day and movie/popular (or discover/movie)
/// endpoints. Fields that are absent in one endpoint are nullable.
class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.voteAverage = 0,
    super.genreIds = const [],
    super.overview,
    super.mediaType,
  });

  MovieEntity toEntity() => this;


  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      overview: json['overview'] as String?,
      mediaType: json['media_type'] as String?,
    );
  }
}
