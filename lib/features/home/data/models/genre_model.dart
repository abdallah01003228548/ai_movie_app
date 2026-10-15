import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

/// Represents a movie genre from the TMDB API.
class GenreModel extends GenreEntity {
  const GenreModel({
    required super.id,
    required super.name,
  });

  GenreEntity toEntity() => this;

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

