import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/domain/use_case/home_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CategoryChipsState {}
class CategoryChipsInitial extends CategoryChipsState {}
class CategoryChipsLoading extends CategoryChipsState {}
class CategoryChipsLoaded extends CategoryChipsState {
  final List<GenreEntity> genres;
  CategoryChipsLoaded(this.genres);
}
class CategoryChipsError extends CategoryChipsState {
  final String message;
  CategoryChipsError(this.message);
}

class CategoryChipsCubit extends Cubit<CategoryChipsState> {
  final GetGenresUseCase _getGenresUseCase;

  CategoryChipsCubit(this._getGenresUseCase) : super(CategoryChipsInitial());

  Future<void> fetchGenres() async {
    emit(CategoryChipsLoading());
    try {
      final genres = await _getGenresUseCase();
      emit(CategoryChipsLoaded(genres));
    } catch (e) {
      emit(CategoryChipsError(e.toString()));
    }
  }
}
