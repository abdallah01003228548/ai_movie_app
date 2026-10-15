import 'dart:async';

import 'package:ai_movie_app/features/favorite/domain/use_case/favorite_use_cases.dart';
import 'package:ai_movie_app/features/favorite/presentation/view_model/favorite_state.dart';
import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final WatchFavoritesUseCase _watchFavoritesUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  StreamSubscription<List<MovieEntity>>? _subscription;

  FavoriteCubit({
    required WatchFavoritesUseCase watchFavoritesUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
  })  : _watchFavoritesUseCase = watchFavoritesUseCase,
        _removeFavoriteUseCase = removeFavoriteUseCase,
        super(const FavoriteLoading()) {
    init();
  }

  void init() {
    _subscription?.cancel();
    emit(const FavoriteLoading());
    try {
      _subscription = _watchFavoritesUseCase().listen(
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
      await _removeFavoriteUseCase(mediaType, id);
    } catch (_) {
      // Stream will stay intact; error can be surfaced if needed
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
