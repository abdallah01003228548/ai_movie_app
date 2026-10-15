import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';
import 'package:ai_movie_app/features/profile/data/data_source/profile_remote_data_source.dart';

// ── Size guard constant ─────────────────────────────────────────────────────
// Base64-encoded string of a 200 KB image ≈ 200 * 1024 * 4/3 ≈ 273 066 chars.
// We compare the encoded length directly rather than carrying the raw bytes.
const _kMaxBase64Length = 200 * 1024 * 4 ~/ 3; // ≈ 273 066

class ProfileRemoteDataSourceImp implements ProfileRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImp({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Helper ────────────────────────────────────────────────────────────────

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) =>
      _firestore.collection('users').doc(uid).collection('profile').doc('settings');

  // ── Streams ───────────────────────────────────────────────────────────────

  @override
  Stream<ProfileEntity> watchProfile() {
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
      return ProfileEntity(
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

  @override
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

  @override
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

  @override
  Future<void> setNotificationsEnabled(bool value) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid)
        .set({'notificationsEnabled': value}, SetOptions(merge: true));
  }

  @override
  Future<void> setLanguage(String code) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid)
        .set({'preferredLanguage': code}, SetOptions(merge: true));
  }

  @override
  Future<void> setCountry(String code) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _settingsDoc(user.uid).set({'country': code}, SetOptions(merge: true));
  }
}
