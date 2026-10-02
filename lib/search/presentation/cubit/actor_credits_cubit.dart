import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ActorCreditsState {}
class ActorCreditsInitial extends ActorCreditsState {}
class ActorCreditsLoading extends ActorCreditsState {}
class ActorCreditsLoaded extends ActorCreditsState {
  final List<MovieModel> credits;
  ActorCreditsLoaded(this.credits);
}
class ActorCreditsError extends ActorCreditsState {
  final String message;
  ActorCreditsError(this.message);
}

class ActorCreditsCubit extends Cubit<ActorCreditsState> {
  final TmdbService _service;

  ActorCreditsCubit(this._service) : super(ActorCreditsInitial());

  Future<void> fetchCredits(int personId) async {
    emit(ActorCreditsLoading());
    try {
      final credits = await _service.personCombinedCredits(personId);
      emit(ActorCreditsLoaded(credits));
    } catch (e) {
      emit(ActorCreditsError(e.toString()));
    }
  }
  
  void clear() {
    emit(ActorCreditsInitial());
  }
}
