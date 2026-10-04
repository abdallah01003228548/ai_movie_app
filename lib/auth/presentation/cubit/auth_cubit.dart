import 'package:ai_movie_app/auth/data/repositories/auth_repository.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _repository.login(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password. Please try again.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'An error occurred. Please try again.';
      }
      emit(AuthFailure(message));
    } catch (_) {
      emit(AuthFailure('An unexpected error occurred.'));
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    emit(AuthLoading());
    try {
      await _repository.signUp(email: email, password: password, fullName: fullName);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Please login instead.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email/Password sign up is not enabled.';
          break;
        default:
          message = e.message ?? 'An error occurred. Please try again.';
      }
      emit(AuthFailure(message));
    } catch (_) {
      emit(AuthFailure('An unexpected error occurred.'));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(AuthInitial());
    } catch (_) {
      emit(AuthFailure('Could not log out.'));
    }
  }
}
