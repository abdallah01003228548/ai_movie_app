import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ── Size guard constant ─────────────────────────────────────────────────────
// Base64-encoded string of a 200 KB image ≈ 200 * 1024 * 4/3 ≈ 273 066 chars.
// We compare the encoded length directly rather than carrying the raw bytes.
const _kMaxBase64Length = 200 * 1024 * 4 ~/ 3; // ≈ 273 066

// ── ProfileData model ───────────────────────────────────────────────────────

class ProfileData {
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

  ProfileData({
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

  ProfileData copyWith({
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
    return ProfileData(
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

// ── ProfileRepository ───────────────────────────────────────────────────────

class ProfileRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Helper ────────────────────────────────────────────────────────────────

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) =>
      _firestore.collection('users').doc(uid).collection('profile').doc('settings');

  // ── Streams ───────────────────────────────────────────────────────────────

  /// Emits live [ProfileData] for the currently signed-in user.
  Stream<ProfileData> watchProfile() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.error('User not logged in');
    }

    return _settingsDoc(user.uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      final base64String = data?['photoBase64'] as String?;
      Uint8List? bytes;
      if (base64String != null) {
        try {
          bytes = base64Decode(base64String);
        } catch (_) {
          bytes = null; // Corrupted field — degrade gracefully
        }
      }
      return ProfileData(
        uid: user.uid,
        email: user.email ?? '',
        photoUrl: user.photoURL,
        fullName: data?['fullName'] as String? ?? user.displayName,
        phoneNumber: data?['phoneNumber'] as String?,
        country: data?['country'] as String?,
        preferredLanguage: data?['preferredLanguage'] as String?,
        notificationsEnabled: data?['notificationsEnabled'] as bool? ?? false,
        photoBytes: bytes,
      );
    });
  }

  /// Emits only the decoded photo bytes for the current user.
  ///
  /// Uses `.distinct()` so unrelated Firestore writes (e.g. toggling
  /// notifications) do NOT re-emit if the `photoBase64` field did not change.
  /// Decoded ONCE here — widgets only receive [Uint8List?], never a string.
  Stream<Uint8List?> watchProfilePhoto() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return _settingsDoc(user.uid)
        .snapshots()
        .map((snap) => snap.data()?['photoBase64'] as String?)
        .distinct() // Skip re-emits when photoBase64 hasn't changed
        .map((base64String) {
      if (base64String == null) return null;
      try {
        return base64Decode(base64String);
      } catch (_) {
        return null;
      }
    });
  }

  // ── Writes ────────────────────────────────────────────────────────────────

  /// Updates mutable profile fields.
  ///
  /// Photo handling (additive to existing behaviour):
  /// - [photoBytes] provided → encodes to base64, applies size guard, persists.
  /// - [removePhoto] true    → deletes the `photoBase64` field from Firestore.
  /// - neither               → leaves `photoBase64` untouched.
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
    Uint8List? photoBytes,
    bool removePhoto = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final updates = <String, dynamic>{};

    if (fullName != null) {
      updates['fullName'] = fullName;
      await user.updateDisplayName(fullName);
    }
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    if (country != null) updates['country'] = country;

    if (removePhoto) {
      updates['photoBase64'] = FieldValue.delete();
    } else if (photoBytes != null) {
      final encoded = base64Encode(photoBytes);
      // ── Size guard ──────────────────────────────────────────────────────
      if (encoded.length > _kMaxBase64Length) {
        throw Exception(
          'Image is too large, please choose a smaller one (max ~200 KB).',
        );
      }
      updates['photoBase64'] = encoded;
    }

    await _settingsDoc(user.uid).set(updates, SetOptions(merge: true));
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid)
        .set({'notificationsEnabled': value}, SetOptions(merge: true));
  }

  Future<void> setLanguage(String code) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid)
        .set({'preferredLanguage': code}, SetOptions(merge: true));
  }

  Future<void> setCountry(String code) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid).set({'country': code}, SetOptions(merge: true));
  }
}
