import 'package:ai_movie_app/features/search/domain/entities/search_result_entity.dart';
import 'package:ai_movie_app/features/search/domain/use_case/search_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SearchMultiState {}
class SearchMultiInitial extends SearchMultiState {}
class SearchMultiLoading extends SearchMultiState {}
class SearchMultiLoaded extends SearchMultiState {
  final SearchResultEntity result;
  SearchMultiLoaded(this.result);
}
class SearchMultiError extends SearchMultiState {
  final String message;
  SearchMultiError(this.message);
}

class SearchMultiCubit extends Cubit<SearchMultiState> {
  final SearchMultiUseCase _searchMultiUseCase;

  SearchMultiCubit(this._searchMultiUseCase) : super(SearchMultiInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchMultiInitial());
      return;
    }
    emit(SearchMultiLoading());
    try {
      final result = await _searchMultiUseCase(query.trim());
      emit(SearchMultiLoaded(result));
    } catch (e) {
      emit(SearchMultiError(e.toString()));
    }
  }

  void clear() {
    emit(SearchMultiInitial());
  }
}
