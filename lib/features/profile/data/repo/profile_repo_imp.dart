import 'dart:typed_data';

import 'package:ai_movie_app/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';
import 'package:ai_movie_app/features/profile/domain/repo/profile_repo_interface.dart';

/// Concrete implementation of [ProfileRepoInterface].
///
/// Delegates all work to [ProfileRemoteDataSource].
class ProfileRepoImp implements ProfileRepoInterface {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepoImp(this._dataSource);

  @override
  Stream<ProfileEntity> watchProfile() => _dataSource.watchProfile();

  @override
  Stream<Uint8List?> watchProfilePhoto() => _dataSource.watchProfilePhoto();

  @override
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
    Uint8List? photoBytes,
    bool removePhoto = false,
  }) =>
      _dataSource.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
        photoBytes: photoBytes,
        removePhoto: removePhoto,
      );

  @override
  Future<void> setNotificationsEnabled(bool value) =>
      _dataSource.setNotificationsEnabled(value);

  @override
  Future<void> setLanguage(String code) => _dataSource.setLanguage(code);

  @override
  Future<void> setCountry(String code) => _dataSource.setCountry(code);
}
