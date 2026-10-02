import 'package:ai_movie_app/home/data/models/search_result.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SearchMultiState {}
class SearchMultiInitial extends SearchMultiState {}
class SearchMultiLoading extends SearchMultiState {}
class SearchMultiLoaded extends SearchMultiState {
  final SearchResult result;
  SearchMultiLoaded(this.result);
}
class SearchMultiError extends SearchMultiState {
  final String message;
  SearchMultiError(this.message);
}

class SearchMultiCubit extends Cubit<SearchMultiState> {
  final TmdbService _service;

  SearchMultiCubit(this._service) : super(SearchMultiInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchMultiInitial());
      return;
    }
    emit(SearchMultiLoading());
    try {
      final result = await _service.searchMulti(query.trim());
      emit(SearchMultiLoaded(result));
    } catch (e) {
      emit(SearchMultiError(e.toString()));
    }
  }
  
  void clear() {
    emit(SearchMultiInitial());
  }
}
