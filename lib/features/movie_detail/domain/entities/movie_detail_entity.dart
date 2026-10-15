class CastMemberEntity {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMemberEntity({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  String? get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;
}

class MovieDetailEntity {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final int? runtime;
  final double voteAverage;
  final String? overview;
  final List<String> genres;
  final List<CastMemberEntity> cast;
  final String? trailerKey;
  final String? certification;
  final String mediaType;

  const MovieDetailEntity({
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
}
