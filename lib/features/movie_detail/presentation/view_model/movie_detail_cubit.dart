import 'package:ai_movie_app/features/movie_detail/domain/use_case/get_movie_detail_use_case.dart';
import 'package:ai_movie_app/features/movie_detail/presentation/view_model/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  MovieDetailCubit(this._getMovieDetailUseCase) : super(MovieDetailInitial());

  Future<void> fetchDetail(int id, String mediaType) async {
    emit(MovieDetailLoading());
    try {
      final data = await _getMovieDetailUseCase(id, mediaType);
      emit(MovieDetailLoaded(data));
    } catch (e) {
      final raw = e.toString();
      final message = raw.startsWith('Exception: ') ? raw.substring(11) : raw;
      emit(MovieDetailError(message));
    }
  }
}
