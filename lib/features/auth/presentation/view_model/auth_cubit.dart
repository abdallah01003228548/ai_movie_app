import 'package:ai_movie_app/features/auth/domain/use_case/auth_use_cases.dart';
import 'package:ai_movie_app/features/auth/presentation/view_model/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _loginUseCase(email: email, password: password);
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
      await _signUpUseCase(
        email: email,
        password: password,
        fullName: fullName,
      );
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
      await _logoutUseCase();
      emit(AuthInitial());
    } catch (_) {
      emit(AuthFailure('Could not log out.'));
    }
  }
}
