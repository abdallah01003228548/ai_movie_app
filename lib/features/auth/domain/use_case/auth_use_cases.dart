import 'package:ai_movie_app/features/auth/domain/repo/auth_repo_interface.dart';

class LoginUseCase {
  final AuthRepoInterface _repository;
  const LoginUseCase(this._repository);

  Future<dynamic> call({required String email, required String password}) =>
      _repository.login(email: email, password: password);
}

class SignUpUseCase {
  final AuthRepoInterface _repository;
  const SignUpUseCase(this._repository);

  Future<dynamic> call({
    required String email,
    required String password,
    required String fullName,
  }) =>
      _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
}

class LogoutUseCase {
  final AuthRepoInterface _repository;
  const LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}

class SendPasswordResetEmailUseCase {
  final AuthRepoInterface _repository;
  const SendPasswordResetEmailUseCase(this._repository);

  Future<void> call(String email) =>
      _repository.sendPasswordResetEmail(email);
}
