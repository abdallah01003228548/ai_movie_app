import 'package:ai_movie_app/home/data/models/genre_model.dart';

/// Represents a single cast member from TMDB credits.
class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  String? get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      character: (json['character'] as String?) ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}

/// Full movie/TV detail returned by
/// GET /movie/{id}?append_to_response=credits,videos,release_dates
/// GET /tv/{id}?append_to_response=credits,videos,content_ratings
class MovieDetailModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final int? runtime; // movie: runtime (min); tv: episode_run_time[0] (min)
  final double voteAverage;
  final String? overview;
  final List<GenreModel> genres;
  final List<CastMember> cast;
  final String? trailerKey; // YouTube video key, null if none found
  final String? certification; // e.g. "PG-13"; null if not found
  final String mediaType; // "movie" or "tv"

  const MovieDetailModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtime,
    required this.voteAverage,
    this.overview,
    required this.genres,
    required this.cast,
    this.trailerKey,
    this.certification,
    required this.mediaType,
  });

  /// Full URL for the poster image (w500), or null if no poster.
  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  /// Full URL for the backdrop image (w780), or null if no backdrop.
  String? get backdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : null;

  /// Star rating on a 0–5 scale (voteAverage / 2).
  double get stars => voteAverage / 2;

  /// Extracts the 4-digit year from [releaseDate], or empty string if absent.
  String get year =>
      (releaseDate != null && releaseDate!.length >= 4)
          ? releaseDate!.substring(0, 4)
          : '';

  /// Human-readable runtime string, e.g. "148 Minutes".
  String get runtimeLabel {
    if (runtime == null || runtime == 0) return '';
    return '$runtime Minutes';
  }

  /// TMDB web page for sharing.
  String get tmdbUrl => 'https://www.themoviedb.org/$mediaType/$id';

  // ── Factory: Movie ──────────────────────────────────────────────────────────

  /// Parses a full TMDB /movie/{id}?append_to_response=credits,videos,release_dates response.
  factory MovieDetailModel.fromMovieJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final credits = json['credits'] as Map<String, dynamic>? ?? {};
    final cast = (credits['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
        .toList();

    final trailerKey = _extractYouTubeTrailerKey(json['videos']);
    final certification = _extractMovieCertification(json['release_dates']);

    return MovieDetailModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: json['overview'] as String?,
      genres: genres,
      cast: cast,
      trailerKey: trailerKey,
      certification: certification,
      mediaType: 'movie',
    );
  }

  // ── Factory: TV ──────────────────────────────────────────────────────────────

  /// Parses a full TMDB /tv/{id}?append_to_response=credits,videos,content_ratings response.
  factory MovieDetailModel.fromTvJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final credits = json['credits'] as Map<String, dynamic>? ?? {};
    final cast = (credits['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
        .toList();

    final trailerKey = _extractYouTubeTrailerKey(json['videos']);
    final certification = _extractTvCertification(json['content_ratings']);

    // episode_run_time is a list; take first if available.
    final runTimes = json['episode_run_time'] as List<dynamic>?;
    final runtime = (runTimes != null && runTimes.isNotEmpty)
        ? runTimes[0] as int?
        : null;

    return MovieDetailModel(
      id: json['id'] as int,
      title: (json['name'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['first_air_date'] as String?,
      runtime: runtime,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: json['overview'] as String?,
      genres: genres,
      cast: cast,
      trailerKey: trailerKey,
      certification: certification,
      mediaType: 'tv',
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static String? _extractYouTubeTrailerKey(dynamic videosSection) {
    if (videosSection == null) return null;
    final results = (videosSection as Map<String, dynamic>)['results'] as List<dynamic>?;
    if (results == null) return null;
    for (final item in results) {
      final v = item as Map<String, dynamic>;
      if (v['site'] == 'YouTube' && v['type'] == 'Trailer') {
        return v['key'] as String?;
      }
    }
    return null;
  }

  static String? _extractMovieCertification(dynamic releaseDatesSection) {
    if (releaseDatesSection == null) return null;
    final results =
        (releaseDatesSection as Map<String, dynamic>)['results'] as List<dynamic>?;
    if (results == null) return null;
    for (final item in results) {
      final entry = item as Map<String, dynamic>;
      if (entry['iso_3166_1'] == 'US') {
        final dates = entry['release_dates'] as List<dynamic>?;
        if (dates != null && dates.isNotEmpty) {
          final cert = (dates[0] as Map<String, dynamic>)['certification'] as String?;
          if (cert != null && cert.isNotEmpty) return cert;
        }
      }
    }
    return null;
  }

  static String? _extractTvCertification(dynamic contentRatingsSection) {
    if (contentRatingsSection == null) return null;
    final results =
        (contentRatingsSection as Map<String, dynamic>)['results'] as List<dynamic>?;
    if (results == null) return null;
    for (final item in results) {
      final entry = item as Map<String, dynamic>;
      if (entry['iso_3166_1'] == 'US') {
        final rating = entry['rating'] as String?;
        if (rating != null && rating.isNotEmpty) return rating;
      }
    }
    return null;
  }
}
