import 'dart:typed_data';

import 'package:ai_movie_app/features/profile/data/repositories/profile_repository.dart';
import 'package:ai_movie_app/features/profile/data/services/image_picker_service.dart';
import 'package:ai_movie_app/features/profile/presentation/cubit/edit_profile_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// Manages transient state for the Edit Profile screen.
///
/// Keeping this separate from [ProfileCubit] avoids bloating the long-lived
/// profile stream cubit with ephemeral UI state (pending photo, save loading).
///
/// Registered with registerFactory so each Edit Profile screen gets a fresh
/// instance (see service_locator.dart).
class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository _repository;
  final ImagePickerService _imagePicker;

  EditProfileCubit(this._repository, this._imagePicker)
      : super(EditProfileIdle());

  // ── Photo picking ─────────────────────────────────────────────────────────

  /// Opens the system gallery / camera and stores the result as a pending
  /// preview. Nothing is written to Firestore until [saveChanges] is called.
  Future<void> pickPhoto(ImageSource source) async {
    try {
      final bytes = await _imagePicker.pickImage(source);
      if (bytes == null) return; // User cancelled — leave state unchanged

      emit(EditProfileIdle(
        pendingPhotoBytes: bytes,
        pendingRemovePhoto: false,
      ));
    } on Exception catch (e) {
      emit(EditProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Marks the photo for removal (pending, not yet persisted).
  void markRemovePhoto() {
    emit(EditProfileIdle(
      pendingPhotoBytes: null,
      pendingRemovePhoto: true,
    ));
  }

  /// Resets any pending photo change without saving.
  void clearPendingPhoto() {
    emit(EditProfileIdle());
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  /// Persists name, phone, and any pending photo change in a single Firestore
  /// write. Emits [EditProfileSaving] → [EditProfileSaved] on success, or
  /// [EditProfileError] on failure (repository propagates the size guard).
  Future<void> saveChanges({
    required String fullName,
    required String phoneNumber,
    Uint8List? pendingPhotoBytes,
    bool removePhoto = false,
  }) async {
    emit(EditProfileSaving());
    try {
      await _repository.updateProfile(
        fullName: fullName.trim(),
        phoneNumber: phoneNumber.trim(),
        photoBytes: pendingPhotoBytes,
        removePhoto: removePhoto,
      );
      emit(EditProfileSaved());
    } on Exception catch (e) {
      emit(EditProfileError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
