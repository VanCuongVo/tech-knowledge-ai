import '../../../domain/entities/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatState({required this.messages, required this.isLoading});

  factory ChatState.initial() {
    return const ChatState(messages: [], isLoading: false);
  }

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
