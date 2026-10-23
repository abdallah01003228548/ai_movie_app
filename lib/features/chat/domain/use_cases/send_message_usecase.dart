import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  const SendMessageUseCase(this.repository);

  Stream<String> call(String message) {
    return repository.sendMessageStream(message);
  }

  Future<String> sendDirect(String message) {
    return repository.sendMessage(message);
  }

  void resetSession() {
    repository.resetSession();
  }
}
