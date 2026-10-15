import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
}
