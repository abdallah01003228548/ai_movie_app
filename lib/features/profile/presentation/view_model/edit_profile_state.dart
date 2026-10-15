import 'dart:typed_data';

/// Sealed states for the Edit Profile screen.
///
/// Separate from [ProfileState] to avoid bloating [ProfileCubit] with
/// transient UI state (pending photo preview, save loading, etc.).
/// Registered with registerFactory in service_locator.dart.
sealed class EditProfileState {}

/// Screen is idle, ready for user input.
class EditProfileIdle extends EditProfileState {
  /// Raw bytes of the photo picked but not yet saved. Null = no pending change.
  final Uint8List? pendingPhotoBytes;

  /// True when the user chose "Remove photo" but hasn't saved yet.
  final bool pendingRemovePhoto;

  EditProfileIdle({
    this.pendingPhotoBytes,
    this.pendingRemovePhoto = false,
  });
}

/// Save is in progress (shows spinner on button).
class EditProfileSaving extends EditProfileState {}

/// Save completed successfully.
class EditProfileSaved extends EditProfileState {}

/// An error occurred (save failed or image too large).
class EditProfileError extends EditProfileState {
  final String message;
  EditProfileError(this.message);
}
