import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class MostPopularState {}
class MostPopularInitial extends MostPopularState {}
class MostPopularLoading extends MostPopularState {}
class MostPopularLoaded extends MostPopularState {
  final List<MovieModel> movies;
  MostPopularLoaded(this.movies);
}
class MostPopularError extends MostPopularState {
  final String message;
  MostPopularError(this.message);
}

class MostPopularCubit extends Cubit<MostPopularState> {
  final TmdbService _service;

  MostPopularCubit(this._service) : super(MostPopularInitial());

  Future<void> fetchMostPopular({int? genreId}) async {
    emit(MostPopularLoading());
    try {
      final movies = await _service.mostPopular(genreId: genreId);
      emit(MostPopularLoaded(movies));
    } catch (e) {
      emit(MostPopularError(e.toString()));
    }
  }
}
