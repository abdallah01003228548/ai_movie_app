class MovieEntity {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final List<int> genreIds;
  final String? overview;
  final String? mediaType;

  const MovieEntity({
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

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : null;

  double get stars => voteAverage / 2;

  String get year =>
      (releaseDate != null && releaseDate!.length >= 4)
          ? releaseDate!.substring(0, 4)
          : '';
}

class GenreEntity {
  final int id;
  final String name;

  const GenreEntity({
    required this.id,
    required this.name,
  });
}

class PersonEntity {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;

  const PersonEntity({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
  });

  String? get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;
}
