import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CategoryChipsState {}
class CategoryChipsInitial extends CategoryChipsState {}
class CategoryChipsLoading extends CategoryChipsState {}
class CategoryChipsLoaded extends CategoryChipsState {
  final List<GenreModel> genres;
  CategoryChipsLoaded(this.genres);
}
class CategoryChipsError extends CategoryChipsState {
  final String message;
  CategoryChipsError(this.message);
}

class CategoryChipsCubit extends Cubit<CategoryChipsState> {
  final TmdbService _service;

  CategoryChipsCubit(this._service) : super(CategoryChipsInitial());

  Future<void> fetchGenres() async {
    emit(CategoryChipsLoading());
    try {
      final genres = await _service.genres();
      emit(CategoryChipsLoaded(genres));
    } catch (e) {
      emit(CategoryChipsError(e.toString()));
    }
  }
}
