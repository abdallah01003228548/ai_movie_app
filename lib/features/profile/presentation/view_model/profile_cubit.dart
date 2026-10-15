import 'dart:async';

import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';
import 'package:ai_movie_app/features/profile/domain/use_case/profile_use_cases.dart';
import 'package:ai_movie_app/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final WatchProfileUseCase _watchProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final SetNotificationsEnabledUseCase _setNotificationsEnabledUseCase;
  final SetLanguageUseCase _setLanguageUseCase;
  final SetCountryUseCase _setCountryUseCase;

  StreamSubscription<ProfileEntity>? _profileSubscription;

  ProfileCubit({
    required WatchProfileUseCase watchProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required SetNotificationsEnabledUseCase setNotificationsEnabledUseCase,
    required SetLanguageUseCase setLanguageUseCase,
    required SetCountryUseCase setCountryUseCase,
  })  : _watchProfileUseCase = watchProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _setNotificationsEnabledUseCase = setNotificationsEnabledUseCase,
        _setLanguageUseCase = setLanguageUseCase,
        _setCountryUseCase = setCountryUseCase,
        super(ProfileInitial()) {
    _watchProfile();
  }

  void _watchProfile() {
    emit(ProfileLoading());
    _profileSubscription?.cancel();
    _profileSubscription = _watchProfileUseCase().listen(
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
      await _updateProfileUseCase(
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
      await _setNotificationsEnabledUseCase(value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setLanguage(String code) async {
    try {
      await _setLanguageUseCase(code);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> setCountry(String code) async {
    try {
      await _setCountryUseCase(code);
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
