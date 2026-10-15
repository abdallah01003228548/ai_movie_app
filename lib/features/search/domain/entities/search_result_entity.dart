import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';

class SearchResultEntity {
  final List<MovieEntity> movies;
  final List<PersonEntity> people;

  const SearchResultEntity({
    required this.movies,
    required this.people,
  });

  bool get isEmpty => movies.isEmpty && people.isEmpty;
  bool get hasMovies => movies.isNotEmpty;
  bool get hasPeople => people.isNotEmpty;
}
