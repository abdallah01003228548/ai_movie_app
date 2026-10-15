import 'package:ai_movie_app/features/home/domain/entities/movie_entity.dart';
import 'package:ai_movie_app/features/search/domain/use_case/search_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ActorCreditsState {}
class ActorCreditsInitial extends ActorCreditsState {}
class ActorCreditsLoading extends ActorCreditsState {}
class ActorCreditsLoaded extends ActorCreditsState {
  final List<MovieEntity> credits;
  ActorCreditsLoaded(this.credits);
}
class ActorCreditsError extends ActorCreditsState {
  final String message;
  ActorCreditsError(this.message);
}

class ActorCreditsCubit extends Cubit<ActorCreditsState> {
  final GetPersonCombinedCreditsUseCase _getPersonCombinedCreditsUseCase;

  ActorCreditsCubit(this._getPersonCombinedCreditsUseCase) : super(ActorCreditsInitial());

  Future<void> fetchCredits(int personId) async {
    emit(ActorCreditsLoading());
    try {
      final credits = await _getPersonCombinedCreditsUseCase(personId);
      emit(ActorCreditsLoaded(credits));
    } catch (e) {
      emit(ActorCreditsError(e.toString()));
    }
  }

  void clear() {
    emit(ActorCreditsInitial());
  }
}
