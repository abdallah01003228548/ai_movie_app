import '../../domain/repositories/chat_repository.dart';
import '../data_sources/gemini_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<String> sendMessageStream(String message) {
    return remoteDataSource.sendMessageStream(message);
  }

  @override
  Future<String> sendMessage(String message) {
    return remoteDataSource.sendMessage(message);
  }

  @override
  void resetSession() {
    remoteDataSource.resetSession();
  }
}
