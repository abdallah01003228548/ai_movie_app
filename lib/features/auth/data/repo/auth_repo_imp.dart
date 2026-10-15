import 'package:ai_movie_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:ai_movie_app/features/auth/domain/repo/auth_repo_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImp implements AuthRepoInterface {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImp(this._remoteDataSource);

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _remoteDataSource.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _remoteDataSource.sendPasswordResetEmail(email);
  }
}
