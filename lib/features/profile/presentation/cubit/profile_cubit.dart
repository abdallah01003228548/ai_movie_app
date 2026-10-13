import 'dart:async';

import 'package:ai_movie_app/profile/data/repositories/profile_repository.dart';
import 'package:ai_movie_app/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  StreamSubscription<ProfileData>? _profileSubscription;

  ProfileCubit(this._repository) : super(ProfileInitial()) {
    _watchProfile();
  }

  void _watchProfile() {
    emit(ProfileLoading());
    _profileSubscription?.cancel();
    _profileSubscription = _repository.watchProfile().listen(
      (data) {
        emit(ProfileLoaded(data));
      },
      onError: (error) {
        emit(ProfileError(error.toString()));
      },
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
  }) async {
    try {
      await _repository.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      // We rely on stream to push new state, but for errors we emit Error state
      // This will break the watch if not careful. Alternatively, we don't emit error here 
      // globally, but we can throw and catch in UI.
      // Let's rethrow for UI to catch.
      rethrow;
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    try {
      await _repository.setNotificationsEnabled(value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setLanguage(String code) async {
    try {
      await _repository.setLanguage(code);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> setCountry(String code) async {
    try {
      await _repository.setCountry(code);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
