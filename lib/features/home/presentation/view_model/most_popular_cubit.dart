import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/domain/use_case/home_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class MostPopularState {}
class MostPopularInitial extends MostPopularState {}
class MostPopularLoading extends MostPopularState {}
class MostPopularLoaded extends MostPopularState {
  final List<MovieEntity> movies;
  MostPopularLoaded(this.movies);
}
class MostPopularError extends MostPopularState {
  final String message;
  MostPopularError(this.message);
}

class MostPopularCubit extends Cubit<MostPopularState> {
  final GetMostPopularUseCase _getMostPopularUseCase;

  MostPopularCubit(this._getMostPopularUseCase) : super(MostPopularInitial());

  Future<void> fetchMostPopular({int? genreId}) async {
    emit(MostPopularLoading());
    try {
      final movies = await _getMostPopularUseCase(genreId: genreId);
      emit(MostPopularLoaded(movies));
    } catch (e) {
      emit(MostPopularError(e.toString()));
    }
  }
}
