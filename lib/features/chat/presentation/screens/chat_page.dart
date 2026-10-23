import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:ai_movie_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:ai_movie_app/features/chat/presentation/widgets/chat_buble.dart';
import 'package:ai_movie_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // If ChatCubit is already provided in the ancestor tree (e.g. from routes),
    // use it; otherwise create a fresh instance from the service locator.
    try {
      context.read<ChatCubit>();
      return const _ChatPageView();
    } catch (_) {
      return BlocProvider(
        create: (_) => getIt<ChatCubit>(),
        child: const _ChatPageView(),
      );
    }
  }
}

class _ChatPageView extends StatefulWidget {
  const _ChatPageView();

  @override
  State<_ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<_ChatPageView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || context.read<ChatCubit>().state.isLoading) return;

    context.read<ChatCubit>().sendMessage(text);
    _messageController.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            tooltip: 'New Chat',
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () {
              context.read<ChatCubit>().resetChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                scrollToBottom();
              },
              builder: (context, state) {
                final messages = state.messages;
                final isLoading = state.isLoading;
                final isTyping =
                    isLoading && (messages.isEmpty || messages.last.isUser);
                final hasError =
                    state is ChatError && state.errorMessage != null;

                if (messages.isEmpty && !isLoading && !hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.movie_filter_outlined,
                            size: 64,
                            color: Colors.white24,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Your Movie AI Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ask for recommendations, movie trivia, actor facts, or what to watch tonight!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final extraItemsCount =
                    (isTyping ? 1 : 0) + (hasError ? 1 : 0);
                final totalItems = messages.length + extraItemsCount;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      final message = messages[index];
                      return ChatBuble(
                        text: message.text,
                        isUser: message.isUser,
                      );
                    }

                    if (isTyping && index == messages.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: const TypingIndicator(),
                          ),
                        ),
                      );
                    }

                    // Friendly error bubble with retry
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.sizeOf(context).width * 0.85,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E1A1A),
                            border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.4),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Notice',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (state as ChatError).errorMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                              if (state.lastFailedMessage != null) ...[
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        context.read<ChatCubit>().retry(),
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Retry',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF1672C9),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                          BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading,
            builder: (context, state) {
              final isLoading = state.isLoading;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: isLoading ? null : (_) => _sendMessage(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Send a Message',
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: IconButton(
                      onPressed: isLoading ? null : _sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: isLoading
                            ? Colors.white24
                            : const Color(0xFF1672C9),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
