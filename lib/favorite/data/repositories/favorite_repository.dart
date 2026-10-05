import 'dart:async';

import 'package:ai_movie_app/home/data/models/movie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository responsible for persisting and syncing user favorites via Cloud Firestore.
///
/// Each user's favorites are stored under:
/// `users/{uid}/favorites/{mediaType}_{id}`
class FavoriteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoriteRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Cannot access favorites: No user is currently logged in.');
    }
    return user.uid;
  }

  String _cleanMediaType(String? mediaType) {
    if (mediaType == null || mediaType.trim().isEmpty) {
      return 'movie';
    }
    return mediaType.trim().toLowerCase();
  }

  String _docId(String? mediaType, int id) => '${_cleanMediaType(mediaType)}_$id';

  /// Watches the current user's favorites collection ordered by newest first.
  Stream<List<MovieModel>> watchFavorites() {
    try {
      final uid = _currentUserId;
      return _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => _fromMap(doc.data())).toList();
      }).handleError((error) {
        if (error is FirebaseException) {
          throw Exception(error.message ?? 'Firestore error: ${error.code}');
        }
        throw Exception(error.toString());
      });
    } on StateError catch (e) {
      return Stream.error(Exception(e.message));
    } catch (e) {
      return Stream.error(Exception('Failed to watch favorites: $e'));
    }
  }

  /// Watches whether a specific movie or show is in the current user's favorites.
  Stream<bool> watchIsFavorite(String? mediaType, int id) {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Stream.value(false);
      }
      final docId = _docId(mediaType, id);
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(docId)
          .snapshots()
          .map((snapshot) => snapshot.exists)
          .handleError((_) => false);
    } catch (_) {
      return Stream.value(false);
    }
  }

  /// Adds a movie/show to the current user's favorites.
  Future<void> add(MovieModel movie) async {
    try {
      final uid = _currentUserId;
      final mediaType = _cleanMediaType(movie.mediaType);
      final docId = _docId(mediaType, movie.id);

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(docId)
          .set({
        'id': movie.id,
        'mediaType': mediaType,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'releaseDate': movie.releaseDate,
        'voteAverage': movie.voteAverage,
        'genreIds': movie.genreIds,
        'overview': movie.overview,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to add to favorites: ${e.code}');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  /// Removes a movie/show from the current user's favorites.
  Future<void> remove(String? mediaType, int id) async {
    try {
      final uid = _currentUserId;
      final cleanType = _cleanMediaType(mediaType);
      final docId = _docId(cleanType, id);

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(docId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to remove from favorites: ${e.code}');
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  MovieModel _fromMap(Map<String, dynamic> data) {
    return MovieModel(
      id: (data['id'] as num?)?.toInt() ?? 0,
      title: (data['title'] as String?) ?? '',
      posterPath: data['posterPath'] as String? ?? data['poster_path'] as String?,
      backdropPath: data['backdropPath'] as String? ?? data['backdrop_path'] as String?,
      releaseDate: data['releaseDate'] as String? ?? data['release_date'] as String?,
      voteAverage: (data['voteAverage'] as num?)?.toDouble() ??
          (data['vote_average'] as num?)?.toDouble() ??
          0.0,
      genreIds: (data['genreIds'] as List<dynamic>? ?? data['genre_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      overview: data['overview'] as String?,
      mediaType: data['mediaType'] as String? ?? data['media_type'] as String?,
    );
  }
}
