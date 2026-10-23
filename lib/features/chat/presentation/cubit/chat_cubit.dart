import 'package:ai_movie_app/core/constant/api_constants.dart';
import 'package:ai_movie_app/features/chat/domain/entities/chat_message.dart';
import 'package:ai_movie_app/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatCubit(this.sendMessageUseCase) : super(const ChatInitial());

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    // Check if the API key is provided
    if (ApiConstants.geminiApiKey.trim().isEmpty) {
      final userMessage = ChatMessage(
        text: trimmed,
        isUser: true,
        timestamp: DateTime.now(),
      );
      emit(ChatError(
        messages: [...state.messages, userMessage],
        errorMessage:
            'Gemini API key is not configured.\nPlease provide your GEMINI_API_KEY in env.json and launch the app with:\nflutter run --dart-define-from-file=env.json',
        lastFailedMessage: trimmed,
      ));
      return;
    }

    final userMessage = ChatMessage(
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final messagesWithUser = [...state.messages, userMessage];
    emit(ChatLoading(messages: messagesWithUser));

    try {
      final responseStream = sendMessageUseCase(trimmed);
      String accumulatedText = '';
      bool hasCreatedGeminiBubble = false;

      await for (final chunk in responseStream) {
        accumulatedText += chunk;

        if (!hasCreatedGeminiBubble) {
          hasCreatedGeminiBubble = true;
          final geminiMessage = ChatMessage(
            text: accumulatedText,
            isUser: false,
            timestamp: DateTime.now(),
          );
          emit(ChatLoading(messages: [...messagesWithUser, geminiMessage]));
        } else {
          final updated = List<ChatMessage>.from(state.messages);
          if (updated.isNotEmpty && !updated.last.isUser) {
            updated[updated.length - 1] =
                updated.last.copyWith(text: accumulatedText);
            emit(ChatLoading(messages: updated));
          }
        }
      }

      emit(ChatSuccess(messages: state.messages));
    } catch (e) {
      final friendlyError = _formatErrorMessage(e);
      emit(ChatError(
        messages: state.messages,
        errorMessage: friendlyError,
        lastFailedMessage: trimmed,
      ));
    }
  }

  void retry() {
    final failedText = state.lastFailedMessage;
    if (failedText != null && failedText.isNotEmpty) {
      sendMessage(failedText);
    }
  }

  void resetChat() {
    sendMessageUseCase.resetSession();
    emit(const ChatInitial());
  }

  String _formatErrorMessage(dynamic error) {
    final str = error.toString().toLowerCase();
    if (str.contains('socketexception') ||
        str.contains('network') ||
        str.contains('connection') ||
        str.contains('failed host lookup') ||
        str.contains('clientexception')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (str.contains('api key') ||
        str.contains('api_key') ||
        str.contains('unauthenticated') ||
        str.contains('invalid api key')) {
      return 'Invalid or missing Gemini API key. Please check your env.json configuration.';
    }
    if (str.contains('quota') ||
        str.contains('resource_exhausted') ||
        str.contains('429')) {
      return 'Gemini rate limit or quota exceeded. Please wait a moment and try again.';
    }
    if (str.contains('gemini api key is missing')) {
      return 'Gemini API key is not configured. Please add GEMINI_API_KEY to env.json and run with --dart-define-from-file=env.json';
    }
    return 'Could not get a response from Gemini. Please try again.';
  }
}
