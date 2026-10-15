import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/home/domain/use_case/home_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TodayCarouselState {}
class TodayCarouselInitial extends TodayCarouselState {}
class TodayCarouselLoading extends TodayCarouselState {}
class TodayCarouselLoaded extends TodayCarouselState {
  final List<MovieEntity> movies;
  TodayCarouselLoaded(this.movies);
}
class TodayCarouselError extends TodayCarouselState {
  final String message;
  TodayCarouselError(this.message);
}

class TodayCarouselCubit extends Cubit<TodayCarouselState> {
  final GetTrendingTodayUseCase _getTrendingTodayUseCase;

  TodayCarouselCubit(this._getTrendingTodayUseCase) : super(TodayCarouselInitial());

  Future<void> fetchTrending() async {
    emit(TodayCarouselLoading());
    try {
      final movies = await _getTrendingTodayUseCase();
      emit(TodayCarouselLoaded(movies));
    } catch (e) {
      emit(TodayCarouselError(e.toString()));
    }
  }
}
