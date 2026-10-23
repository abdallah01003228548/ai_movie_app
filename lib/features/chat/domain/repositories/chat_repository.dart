abstract class ChatRepository {
  /// Stream responses chunk by chunk from Gemini for real-time conversation.
  Stream<String> sendMessageStream(String message);

  /// Send a message and wait for the full response from Gemini.
  Future<String> sendMessage(String message);

  /// Reset the conversation history in the current chat session.
  void resetSession();
}
