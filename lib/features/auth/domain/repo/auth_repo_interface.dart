abstract interface class AuthRepoInterface {
  Future<dynamic> login({required String email, required String password});
  Future<dynamic> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
}
