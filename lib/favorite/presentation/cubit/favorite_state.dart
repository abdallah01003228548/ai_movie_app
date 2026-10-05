import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:equatable/equatable.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

final class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

final class FavoriteLoaded extends FavoriteState {
  final List<MovieModel> items;

  const FavoriteLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

final class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
