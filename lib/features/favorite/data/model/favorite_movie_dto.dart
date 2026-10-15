import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

class FavoriteMovieDto {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double voteAverage;
  final List<int> genreIds;
  final String? overview;
  final String? mediaType;

  const FavoriteMovieDto({
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

  factory FavoriteMovieDto.fromMap(Map<String, dynamic> data) {
    return FavoriteMovieDto(
      id: (data['id'] as num?)?.toInt() ?? 0,
      title: (data['title'] as String?) ?? '',
      posterPath: data['posterPath'] as String? ?? data['poster_path'] as String?,
      backdropPath: data['backdropPath'] as String? ?? data['backdrop_path'] as String?,
      releaseDate: data['releaseDate'] as String? ?? data['release_date'] as String?,
      voteAverage: (data['voteAverage'] as num?)?.toDouble() ??
          (data['vote_average'] as num?)?.toDouble() ??
          0.0,
      genreIds: (data['genreIds'] as List<dynamic>? ?? data['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      overview: data['overview'] as String?,
      mediaType: data['mediaType'] as String? ?? data['media_type'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mediaType': mediaType,
      'title': title,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'genreIds': genreIds,
      'overview': overview,
    };
  }

  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      genreIds: genreIds,
      overview: overview,
      mediaType: mediaType,
    );
  }

  factory FavoriteMovieDto.fromEntity(MovieEntity entity) {
    return FavoriteMovieDto(
      id: entity.id,
      title: entity.title,
      posterPath: entity.posterPath,
      backdropPath: entity.backdropPath,
      releaseDate: entity.releaseDate,
      voteAverage: entity.voteAverage,
      genreIds: entity.genreIds,
      overview: entity.overview,
      mediaType: entity.mediaType,
    );
  }
}
