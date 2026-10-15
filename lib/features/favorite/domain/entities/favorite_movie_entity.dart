class FavoriteMovieEntity {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final List<int> genreIds;
  final String? overview;
  final String? mediaType;

  const FavoriteMovieEntity({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
    this.overview,
    this.mediaType,
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
}
