import 'package:ai_movie_app/features/home/data/models/genre_model.dart';
import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';

class CastMemberDto {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMemberDto({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  String? get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;

  factory CastMemberDto.fromJson(Map<String, dynamic> json) {
    return CastMemberDto(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      character: (json['character'] as String?) ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }

  CastMemberEntity toEntity() {
    return CastMemberEntity(
      id: id,
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }
}

typedef CastMember = CastMemberDto;

class MovieDetailDto {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final int? runtime;
  final double voteAverage;
  final String? overview;
  final List<GenreModel> genres;
  final List<CastMemberDto> cast;
  final String? trailerKey;
  final String? certification;
  final String mediaType;

  const MovieDetailDto({
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

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : null;

  double get stars => voteAverage / 2;

  String get year =>
      (releaseDate != null && releaseDate!.length >= 4)
          ? releaseDate!.substring(0, 4)
          : '';

  String get runtimeLabel {
    if (runtime == null || runtime == 0) return '';
    return '$runtime Minutes';
  }

  String get tmdbUrl => 'https://www.themoviedb.org/$mediaType/$id';

  factory MovieDetailDto.fromMovieJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final credits = json['credits'] as Map<String, dynamic>? ?? {};
    final cast = (credits['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastMemberDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final trailerKey = _extractYouTubeTrailerKey(json['videos']);
    final certification = _extractMovieCertification(json['release_dates']);

    return MovieDetailDto(
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

  factory MovieDetailDto.fromTvJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final credits = json['credits'] as Map<String, dynamic>? ?? {};
    final cast = (credits['cast'] as List<dynamic>? ?? [])
        .take(20)
        .map((e) => CastMemberDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final trailerKey = _extractYouTubeTrailerKey(json['videos']);
    final certification = _extractTvCertification(json['content_ratings']);

    final runTimes = json['episode_run_time'] as List<dynamic>?;
    final runtime = (runTimes != null && runTimes.isNotEmpty)
        ? runTimes[0] as int?
        : null;

    return MovieDetailDto(
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

  MovieDetailEntity toEntity() {
    return MovieDetailEntity(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      runtime: runtime,
      voteAverage: voteAverage,
      overview: overview,
      genres: genres.map((g) => g.name).toList(),
      cast: cast.map((c) => c.toEntity()).toList(),
      trailerKey: trailerKey,
      certification: certification,
      mediaType: mediaType,
    );
  }

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

typedef MovieDetailModel = MovieDetailDto;
