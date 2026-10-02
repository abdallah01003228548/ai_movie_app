import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/data/models/person_model.dart';

/// Holds the split result of a [TmdbService.searchMulti] call.
///
/// [movies] contains all results where media_type == "movie" or "tv".
/// [people] contains all results where media_type == "person".
class SearchResult {
  final List<MovieModel> movies;
  final List<PersonModel> people;

  const SearchResult({
    required this.movies,
    required this.people,
  });

  bool get isEmpty => movies.isEmpty && people.isEmpty;
  bool get hasMovies => movies.isNotEmpty;
  bool get hasPeople => people.isNotEmpty;
}
