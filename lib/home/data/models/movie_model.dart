/// Represents a movie from the TMDB API.
///
/// Used by both the trending/movie/day and movie/popular (or discover/movie)
/// endpoints. Fields that are absent in one endpoint are nullable.
class MovieModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final List<int> genreIds;
  final String? overview;
  /// "movie", "tv", or null (not set for non-search endpoints).
  final String? mediaType;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0,
    this.genreIds = const [],
    this.overview,
    this.mediaType,
  });

  /// Full URL for the poster image, or null if no poster is available.
  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  /// Full URL for the backdrop image, or null if no backdrop is available.
  String? get backdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : null;

  /// Star rating on a 0–5 scale (voteAverage / 2).
  double get stars => voteAverage / 2;

  /// Extracts the 4-digit year from [releaseDate], or empty string if absent.
  String get year =>
      (releaseDate != null && releaseDate!.length >= 4)
          ? releaseDate!.substring(0, 4)
          : '';

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
