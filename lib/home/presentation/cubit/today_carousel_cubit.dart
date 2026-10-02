import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TodayCarouselState {}
class TodayCarouselInitial extends TodayCarouselState {}
class TodayCarouselLoading extends TodayCarouselState {}
class TodayCarouselLoaded extends TodayCarouselState {
  final List<MovieModel> movies;
  TodayCarouselLoaded(this.movies);
}
class TodayCarouselError extends TodayCarouselState {
  final String message;
  TodayCarouselError(this.message);
}

class TodayCarouselCubit extends Cubit<TodayCarouselState> {
  final TmdbService _service;

  TodayCarouselCubit(this._service) : super(TodayCarouselInitial());

  Future<void> fetchTrending() async {
    emit(TodayCarouselLoading());
    try {
      final movies = await _service.trendingToday();
      emit(TodayCarouselLoaded(movies));
    } catch (e) {
      emit(TodayCarouselError(e.toString()));
    }
  }
}
