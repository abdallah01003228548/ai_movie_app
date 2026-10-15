import 'dart:typed_data';

import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';

/// Abstract contract for the Profile repository.
///
/// Implemented by [ProfileRepoImp] in the data layer.
abstract class ProfileRepoInterface {
  /// Emits live [ProfileEntity] for the currently signed-in user.
  Stream<ProfileEntity> watchProfile();

  /// Emits only the decoded photo bytes for the current user.
  Stream<Uint8List?> watchProfilePhoto();

  /// Updates mutable profile fields.
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
    Uint8List? photoBytes,
    bool removePhoto = false,
  });

  Future<void> setNotificationsEnabled(bool value);

  Future<void> setLanguage(String code);

  Future<void> setCountry(String code);
}
