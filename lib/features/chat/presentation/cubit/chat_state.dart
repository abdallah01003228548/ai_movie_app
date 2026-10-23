import '../../domain/entities/chat_message.dart';

sealed class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;
  final String? lastFailedMessage;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
    this.lastFailedMessage,
  });
}

class ChatInitial extends ChatState {
  const ChatInitial() : super(messages: const [], isLoading: false);
}

class ChatLoading extends ChatState {
  const ChatLoading({
    required super.messages,
    super.errorMessage,
    super.lastFailedMessage,
  }) : super(isLoading: true);
}

class ChatSuccess extends ChatState {
  const ChatSuccess({
    required super.messages,
  }) : super(isLoading: false, errorMessage: null, lastFailedMessage: null);
}

class ChatError extends ChatState {
  const ChatError({
    required super.messages,
    required super.errorMessage,
    super.lastFailedMessage,
  }) : super(isLoading: false);
}
