import 'package:ai_movie_app/core/constant/api_constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class GeminiRemoteDataSource {
  Stream<String> sendMessageStream(String message);
  Future<String> sendMessage(String message);
  void resetSession();
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  GenerativeModel? _model;
  ChatSession? _chatSession;

  ChatSession _getOrCreateChatSession() {
    if (_chatSession != null) {
      return _chatSession!;
    }

    final apiKey = ApiConstants.geminiApiKey.trim();
    if (apiKey.isEmpty) {
      throw StateError(
        'Gemini API key is missing. Please provide your GEMINI_API_KEY in env.json and run the app with --dart-define-from-file=env.json',
      );
    }

    _model ??= GenerativeModel(
      model: 'gemini-3.8-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        'You are a friendly movie assistant. Recommend movies, answer questions about them, and reply in the same language the user writes in.',
      ),
    );

    _chatSession = _model!.startChat();
    return _chatSession!;
  }

  @override
  Stream<String> sendMessageStream(String message) async* {
    final session = _getOrCreateChatSession();
    final responseStream = session.sendMessageStream(Content.text(message));

    await for (final chunk in responseStream) {
      final chunkText = chunk.text;
      if (chunkText != null && chunkText.isNotEmpty) {
        yield chunkText;
      }
    }
  }

  @override
  Future<String> sendMessage(String message) async {
    final session = _getOrCreateChatSession();
    final response = await session.sendMessage(Content.text(message));
    return response.text ?? '';
  }

  @override
  void resetSession() {
    _chatSession = null;
  }
}
