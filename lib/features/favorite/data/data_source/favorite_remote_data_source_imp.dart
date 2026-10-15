import 'package:ai_movie_app/features/favorite/data/data_source/favorite_remote_data_source.dart';
import 'package:ai_movie_app/features/favorite/data/model/favorite_movie_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRemoteDataSourceImp implements FavoriteRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoriteRemoteDataSourceImp({
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

  @override
  Stream<List<FavoriteMovieDto>> watchFavorites() {
    try {
      final uid = _currentUserId;
      return _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => FavoriteMovieDto.fromMap(doc.data())).toList();
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

  @override
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

  @override
  Future<void> addFavorite(FavoriteMovieDto movie) async {
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
        ...movie.toMap(),
        'addedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to add to favorites: ${e.code}');
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFavorite(String? mediaType, int id) async {
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
}
