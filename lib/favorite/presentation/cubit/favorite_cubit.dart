import 'dart:async';

import 'package:ai_movie_app/favorite/data/repositories/favorite_repository.dart';
import 'package:ai_movie_app/favorite/presentation/cubit/favorite_state.dart';
import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;
  StreamSubscription<List<MovieModel>>? _subscription;

  FavoriteCubit(this._repository) : super(const FavoriteLoading()) {
    init();
  }

  void init() {
    _subscription?.cancel();
    emit(const FavoriteLoading());
    try {
      _subscription = _repository.watchFavorites().listen(
        (items) {
          emit(FavoriteLoaded(items));
        },
        onError: (error) {
          emit(FavoriteError(error is Exception ? error.toString().replaceAll('Exception: ', '') : error.toString()));
        },
      );
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void retry() {
    init();
  }

  Future<void> removeFavorite(String? mediaType, int id) async {
    try {
      await _repository.remove(mediaType, id);
    } catch (e) {
      // Stream will stay intact; error can be surfaced if needed
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
