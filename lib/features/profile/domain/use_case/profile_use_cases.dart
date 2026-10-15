import 'dart:typed_data';

import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';
import 'package:ai_movie_app/features/profile/domain/repo/profile_repo_interface.dart';

/// Watches the full profile data stream.
class WatchProfileUseCase {
  final ProfileRepoInterface _repo;
  WatchProfileUseCase(this._repo);

  Stream<ProfileEntity> call() => _repo.watchProfile();
}

/// Watches the profile photo bytes stream.
class WatchProfilePhotoUseCase {
  final ProfileRepoInterface _repo;
  WatchProfilePhotoUseCase(this._repo);

  Stream<Uint8List?> call() => _repo.watchProfilePhoto();
}

/// Updates mutable profile fields.
class UpdateProfileUseCase {
  final ProfileRepoInterface _repo;
  UpdateProfileUseCase(this._repo);

  Future<void> call({
    String? fullName,
    String? phoneNumber,
    String? country,
    Uint8List? photoBytes,
    bool removePhoto = false,
  }) =>
      _repo.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
        photoBytes: photoBytes,
        removePhoto: removePhoto,
      );
}

/// Sets notification preference.
class SetNotificationsEnabledUseCase {
  final ProfileRepoInterface _repo;
  SetNotificationsEnabledUseCase(this._repo);

  Future<void> call(bool value) => _repo.setNotificationsEnabled(value);
}

/// Sets language preference.
class SetLanguageUseCase {
  final ProfileRepoInterface _repo;
  SetLanguageUseCase(this._repo);

  Future<void> call(String code) => _repo.setLanguage(code);
}

/// Sets country preference.
class SetCountryUseCase {
  final ProfileRepoInterface _repo;
  SetCountryUseCase(this._repo);

  Future<void> call(String code) => _repo.setCountry(code);
}
