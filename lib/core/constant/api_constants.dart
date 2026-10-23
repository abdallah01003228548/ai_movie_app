abstract final class ApiConstants {
  /// Gemini API Key loaded from compile-time environment.
  /// Run with: flutter run --dart-define-from-file=env.json
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
}
