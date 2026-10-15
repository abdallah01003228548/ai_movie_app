import 'dart:typed_data';

/// Clean domain entity representing a user profile.
///
/// Contains only the essential fields without any serialisation logic,
/// Firebase dependencies, or framework imports.
class ProfileEntity {
  final String uid;
  final String email;

  /// Legacy URL-based photo (kept for back-compat; normally null for new sign-ups).
  final String? photoUrl;

  final String? fullName;
  final String? phoneNumber;
  final String? country;
  final String? preferredLanguage;
  final bool notificationsEnabled;

  /// Decoded bytes of the profile photo stored as base64 in Firestore.
  /// Decoded ONCE in the repository's stream; never decoded inside a widget.
  final Uint8List? photoBytes;

  ProfileEntity({
    required this.uid,
    required this.email,
    this.photoUrl,
    this.fullName,
    this.phoneNumber,
    this.country,
    this.preferredLanguage,
    required this.notificationsEnabled,
    this.photoBytes,
  });

  ProfileEntity copyWith({
    String? uid,
    String? email,
    String? photoUrl,
    String? fullName,
    String? phoneNumber,
    String? country,
    String? preferredLanguage,
    bool? notificationsEnabled,
    Uint8List? photoBytes,
    bool clearPhotoBytes = false,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      photoBytes: clearPhotoBytes ? null : (photoBytes ?? this.photoBytes),
    );
  }
}
